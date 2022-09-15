import {
  ForbiddenException,
  Injectable,
  InternalServerErrorException,
  Logger,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthDto } from './dto';
import * as argon2 from 'argon2';
import { PrismaService } from 'src/prisma/prisma.service';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
import { JwtService } from '@nestjs/jwt';
import { UserService } from 'src/user/user.service';
import { Tokens } from './types';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private prisma: PrismaService, private userService: UserService, private jwt: JwtService) {}

  async register(
    authDto: AuthDto,
  ): Promise<{ id: number; username: string; access_token: string; refresh_token: string }> {
    try {
      // create new user without access and refresh token
      const passwordHash = await argon2.hash(authDto.password);
      const createdUser = await this.userService.create(authDto.username, passwordHash);

      // generate tokens and update the user
      const tokens = await this._generateTokens(createdUser.id, createdUser.username);
      await this.userService.updateTokens(createdUser.id, tokens.accessToken, tokens.refreshToken);

      return {
        id: createdUser.id,
        username: createdUser.username,
        access_token: tokens.accessToken,
        refresh_token: tokens.refreshToken,
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

  async login(authDto: AuthDto): Promise<Tokens> {
    const user = await this.prisma.user.findUnique({
      where: {
        username: authDto.username,
      },
    });

    if (!user) {
      throw new ForbiddenException('Invalid username or password');
    }

    const passwordValid = await argon2.verify(user.password, authDto.password);
    if (!passwordValid) {
      throw new ForbiddenException('Invalid username or password');
    }

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(user.id, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  async refresh(userId: number, refreshToken: string): Promise<Tokens> {
    const user = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user || !user.refresh_token || !(await argon2.verify(user.refresh_token, refreshToken))) {
      throw new UnauthorizedException();
    }

    const tokens = await this._generateTokens(user.id, user.username);
    await this.userService.updateTokens(user.id, tokens.accessToken, tokens.refreshToken);
    return tokens;
  }

  private async _generateTokens(userId: number, username: string): Promise<Tokens> {
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
