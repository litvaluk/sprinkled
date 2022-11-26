import { ForbiddenException, Injectable, InternalServerErrorException, Logger, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma';
import { UserService } from '../user';
import { CreateUserDto } from '../user/dto';
import { LoginDto } from './dto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private prisma: PrismaService, private userService: UserService, private jwt: JwtService) {}

  async register(createUserDto: CreateUserDto) {
    try {
      const createdUser = await this.userService.create(createUserDto);
      const deviceId = await this.userService.addDeviceIfNeeded(createUserDto.deviceId, createdUser.id);

      const tokens = await this._generateTokens(createdUser.id, createdUser.username);
      await this.userService.updateTokens(deviceId, tokens.accessToken, tokens.refreshToken);

      return {
        id: createdUser.id,
        username: createdUser.username,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      };
    } catch (error) {
      if (error instanceof PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException(['Username or email already taken.']);
        }
      } else {
        throw new InternalServerErrorException();
      }
    }
  }

  async login(loginDto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: {
        username: loginDto.username,
      },
      include: {
        devices: {
          include: {
            users: true,
          },
        },
      },
    });

    if (!user) {
      throw new ForbiddenException(['Invalid username or password.']);
    }

    const passwordValid = await argon2.verify(user.password, loginDto.password);
    if (!passwordValid) {
      throw new ForbiddenException(['Invalid username or password.']);
    }

    const deviceId = await this.userService.addDeviceIfNeeded(loginDto.deviceId, user.id);

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(deviceId, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  async refresh(userId: number, refreshToken: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
      include: {
        devices: true,
      },
    });

    if (!user) {
      throw new UnauthorizedException();
    }

    const device = user.devices.find(async (d) => {
      if (!d.refreshToken) {
        return false;
      }
      return await argon2.verify(d.refreshToken, refreshToken);
    });

    if (!device) {
      throw new UnauthorizedException();
    }

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(device.deviceId, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  async logout(deviceId: string) {
    await this.userService.invalidateTokens(deviceId);
  }

  private async _generateTokens(userId: number, username: string) {
    const payload = {
      sub: userId,
      username,
    };

    const accessToken = await this.jwt.signAsync(payload, {
      expiresIn: process.env.JWT_ACCESS_TOKEN_EXPIRATION_TIME,
      secret: process.env.JWT_ACCESS_TOKEN_SECRET,
    });

    const refreshToken = await this.jwt.signAsync(payload, {
      expiresIn: process.env.JWT_REFRESH_TOKEN_EXPIRATION_TIME,
      secret: process.env.JWT_REFRESH_TOKEN_SECRET,
    });

    return {
      accessToken: accessToken,
      refreshToken: refreshToken,
    };
  }
}
