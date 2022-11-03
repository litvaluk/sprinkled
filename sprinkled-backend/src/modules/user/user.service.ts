import { Injectable, NotFoundException } from '@nestjs/common';
import { User } from '@prisma/client';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma';
import { CreateUserDto } from './dto';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  // creates user with no tokens
  async create(createUserDto: CreateUserDto) {
    const createdUser = await this.prisma.user.create({
      data: {
        username: createUserDto.username,
        email: createUserDto.email,
        password: await argon2.hash(createUserDto.password),
        accessToken: '',
        refreshToken: '',
      },
    });

    const device = await this.prisma.device.findUnique({
      where: {
        deviceId: createUserDto.deviceId,
      },
    });

    if (!device) {
      // if device does not exist, create it and assign it to the user
      await this.prisma.device.create({
        data: {
          deviceId: createUserDto.deviceId,
          users: {
            connect: {
              id: createdUser.id,
            },
          },
        },
      });
    } else {
      // if device exists, assign it to the user
      await this.prisma.device.update({
        where: {
          deviceId: createUserDto.deviceId,
        },
        data: {
          users: {
            connect: {
              id: createdUser.id,
            },
          },
        },
      });
    }

    return createdUser;
  }

  async findAll(): Promise<User[]> {
    return await this.prisma.user.findMany();
  }

  async findAllSafe() {
    return await this.prisma.user.findMany({
      select: {
        id: true,
        username: true,
        email: true,
      },
    });
  }

  async findOne(id: number) {
    let user = await this.prisma.user.findUnique({
      where: {
        id: id,
      },
    });
    if (!user) {
      throw new NotFoundException();
    }
    return user;
  }

  async findOneSafe(id: number) {
    let user = await this.prisma.user.findUnique({
      where: {
        id: id,
      },
      select: {
        id: true,
        username: true,
        email: true,
      },
    });
    if (!user) {
      throw new NotFoundException();
    }
    return user;
  }

  async delete(userId: number) {
    await this.prisma.user.delete({
      where: {
        id: userId,
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

  async invalidateTokens(userId: number) {
    await this.prisma.user.update({
      where: {
        id: userId,
      },
      data: {
        accessToken: '',
        refreshToken: '',
      },
    });
  }
}
