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
      // create new user without access and refresh token
      const createdUser = await this.userService.create(createUserDto);

      // generate tokens and update the user
      const tokens = await this._generateTokens(createdUser.id, createdUser.username);
      await this.userService.updateTokens(createdUser.id, tokens.accessToken, tokens.refreshToken);

      return {
        id: createdUser.id,
        username: createdUser.username,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      };
    } catch (error) {
      if (error instanceof PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException('Username already taken');
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
    });

    if (!user) {
      throw new ForbiddenException('Invalid username or password');
    }

    const passwordValid = await argon2.verify(user.password, loginDto.password);
    if (!passwordValid) {
      throw new ForbiddenException('Invalid username or password');
    }

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(user.id, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  async refresh(userId: number, refreshToken: string) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user || !user.refreshToken || !(await argon2.verify(user.refreshToken, refreshToken))) {
      throw new UnauthorizedException();
    }

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(user.id, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  async logout(userId: number) {
    await this.userService.invalidateTokens(userId);
  }

  private async _generateTokens(userId: number, username: string) {
    const payload = {
      sub: userId,
      username,
    };

    const accessToken = await this.jwt.signAsync(payload, {
      expiresIn: '1h',
      secret: process.env.JWT_ACCESS_TOKEN_SECRET,
    });

    const refreshToken = await this.jwt.signAsync(payload, {
      expiresIn: '7d',
      secret: process.env.JWT_REFRESH_TOKEN_SECRET,
    });

    return {
      accessToken: accessToken,
      refreshToken: refreshToken,
    };
  }
}
