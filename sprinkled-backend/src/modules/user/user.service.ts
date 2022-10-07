import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma';
import { CreateUserDto } from './dto';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  // creates user with no tokens
  async create(createUserDto: CreateUserDto): Promise<User> {
    return await this.prisma.user.create({
      data: {
        username: createUserDto.username,
        email: createUserDto.email,
        password: await argon2.hash(createUserDto.password),
        accessToken: '',
        refreshToken: '',
      },
    });
  }

  async findAll(): Promise<User[]> {
    return await this.prisma.user.findMany();
  }

  async findOne(id: number): Promise<User> {
    return await this.prisma.user.findUnique({
      where: {
        id: id,
      },
    });
  }

  async updateTokens(userId: number, accessToken: string, refreshToken: string) {
    const hashedAccessToken = await argon2.hash(accessToken);
    const hashedRefreshToken = await argon2.hash(refreshToken);

    await this.prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        accessToken: hashedAccessToken,
        refreshToken: hashedRefreshToken,
      },
    });
  }
}
