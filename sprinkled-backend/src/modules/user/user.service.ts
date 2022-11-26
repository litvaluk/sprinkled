import { Injectable, NotFoundException } from '@nestjs/common';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma';
import { CreateUserDto } from './dto';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    const createdUser = await this.prisma.user.create({
      data: {
        username: createUserDto.username,
        email: createUserDto.email,
        password: await argon2.hash(createUserDto.password),
      },
    });

    return createdUser;
  }

  async findAll() {
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
      include: {
        devices: true,
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

  async updateTokens(deviceId: string, accessToken: string, refreshToken: string) {
    const hashedAccessToken = await argon2.hash(accessToken);
    const hashedRefreshToken = await argon2.hash(refreshToken);

    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        accessToken: hashedAccessToken,
        refreshToken: hashedRefreshToken,
        tokensUpdatedAt: new Date(),
      },
    });
  }

  async invalidateTokens(deviceId: string) {
    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        accessToken: '',
        refreshToken: '',
      },
    });
  }

  async addDeviceIfNeeded(deviceId: string, userId: number) {
    let device = await this.prisma.device.findUnique({
      where: {
        deviceId: deviceId,
      },
    });

    if (!device) {
      // if device does not exist, create it and assign it to the user
      device = await this.prisma.device.create({
        data: {
          deviceId: deviceId,
          users: {
            connect: {
              id: userId,
            },
          },
          accessToken: '',
          refreshToken: '',
        },
      });
    } else {
      // if device exists, assign it to the user
      await this.prisma.device.update({
        where: {
          deviceId: deviceId,
        },
        data: {
          users: {
            connect: {
              id: userId,
            },
          },
        },
      });
    }

    return device.deviceId;
  }
}
