import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma';
import { CreateTeamDto, UpdateTeamDto } from './dto';

@Injectable()
export class TeamService {
  constructor(private prisma: PrismaService) {}

  async create(createTeamDto: CreateTeamDto, creatorId: number) {
    return await this.prisma.team.create({
      data: {
        ...createTeamDto,
        creatorId: creatorId,
        users: {
          connect: {
            id: creatorId,
          },
        },
      },
    });
  }

  async findAll() {
    return await this.prisma.team.findMany();
  }

  async findAllForUser(userId: number) {
    return await this.prisma.team.findMany({
      where: {
        users: {
          some: {
            id: userId,
          },
        },
      },
    });
  }

  async findAllForUserSummary(userId: number) {
    return await this.prisma.team.findMany({
      where: {
        users: {
          some: {
            id: userId,
          },
        },
      },
      select: {
        id: true,
        name: true,
        place: {
          select: {
            id: true,
            name: true,
            plantEntries: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
      },
    });
  }

  async findOne(id: number) {
    return await this.prisma.team.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateTeamDto: UpdateTeamDto) {
    return await this.prisma.team.update({
      where: {
        id: id,
      },
      data: {
        ...updateTeamDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.team.delete({
      where: {
        id: id,
      },
    });
  }

  async getTeamMembers(id: number) {
    let fetched = await this.prisma.team.findUnique({
      where: {
        id: id,
      },
      select: {
        users: {
          select: {
            id: true,
            username: true,
          },
        },
      },
    });
    return fetched.users;
  }

  async addTeamMember(id: number, userId: number) {
    return await this.prisma.team.update({
      where: {
        id: id,
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

  async removeTeamMember(id: number, userId: number) {
    return await this.prisma.team.update({
      where: {
        id: id,
      },
      data: {
        users: {
          disconnect: {
            id: userId,
          },
        },
      },
    });
  }
}
