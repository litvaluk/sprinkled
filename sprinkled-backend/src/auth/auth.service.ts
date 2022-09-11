import { ForbiddenException, Injectable, Logger } from '@nestjs/common';
import { AuthDto } from './dto';
import * as argon from 'argon2';
import { PrismaService } from 'src/prisma/prisma.service';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private prisma: PrismaService, private jwt: JwtService) {}

  async register(authDto: AuthDto): Promise<{ id: number; username: string }> {
    try {
      const passwordHash = await argon.hash(authDto.password);
      return await this.prisma.user.create({
        data: {
          username: authDto.username,
          password: passwordHash,
        },
        select: {
          id: true,
          username: true,
        },
      });
    } catch (error) {
      if (error instanceof PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException('Username already taken');
        }
      }
    }
  }

  async login(authDto: AuthDto): Promise<{ access_token: string }> {
    const user = await this.prisma.user.findUnique({
      where: {
        username: authDto.username,
      },
    });

    if (!user) {
      throw new ForbiddenException('Invalid username or password');
    }

    const passwordValid = await argon.verify(user.password, authDto.password);
    if (!passwordValid) {
      throw new ForbiddenException('Invalid username or password');
    }

    return this._signToken(user.id, user.username);
  }

  private async _signToken(userId: number, username: string): Promise<{ access_token: string }> {
    const payload = {
      sub: userId,
      username,
    };

    const token = await this.jwt.signAsync(payload, {
      expiresIn: '1h',
      secret: process.env.JWT_SECRET,
    });

    return {
      access_token: token,
    };
  }
}
