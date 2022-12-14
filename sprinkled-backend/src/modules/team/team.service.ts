import { ForbiddenException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma';
import { CreateTeamDto, UpdateTeamDto } from './dto';

@Injectable()
export class TeamService {
  constructor(private prisma: PrismaService) {}

  async create(createTeamDto: CreateTeamDto, creatorId: number) {
    return await this.prisma.team.create({
      data: {
        ...createTeamDto,
        users: {
          connect: {
            id: creatorId,
          },
        },
        admins: {
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
    let teams = await this.prisma.team.findMany({
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
        places: {
          select: {
            id: true,
            name: true,
            plantEntries: {
              select: {
                id: true,
                name: true,
                headerPictureUrl: true,
              },
            },
          },
        },
      },
    });
    let personalTeam = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
      select: {
        id: true,
        places: {
          select: {
            id: true,
            name: true,
            plantEntries: {
              select: {
                id: true,
                name: true,
                headerPictureUrl: true,
              },
            },
          },
        },
      },
    });
    teams.unshift({
      name: 'Personal',
      ...personalTeam,
      id: 0,
    });
    return teams;
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
        admins: {
          select: {
            id: true,
          },
        },
      },
    });

    return fetched.users.map((user) => {
      return {
        id: user.id,
        username: user.username,
        isAdmin: fetched.admins.some((admin) => admin.id === user.id),
      };
    });
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
    let team = await this.prisma.team.findUnique({
      where: {
        id: id,
      },
      include: {
        users: true,
        admins: true,
      },
    });

    if (team.users.length === 1) {
      throw new ForbiddenException('Unable to remove last team member');
    }

    if (team.admins.length === 1 && team.admins.find((admin) => admin.id === userId)) {
      throw new ForbiddenException('Unable to remove last admin');
    }

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
        admins: {
          disconnect: {
            id: userId,
          },
        },
      },
    });
  }

  async giveAdminRights(id: number, userId: number, byUserId: number) {
    let team = await this.prisma.team.findUnique({
      where: {
        id: id,
      },
      include: {
        admins: true,
      },
    });

    if (!team.admins.find((admin) => admin.id === byUserId)) {
      throw new ForbiddenException('Unable to give admin rights by a non-admin user');
    }

    return await this.prisma.team.update({
      where: {
        id: id,
      },
      data: {
        admins: {
          connect: {
            id: userId,
          },
        },
      },
    });
  }

  async removeAdminRights(id: number, userId: number, byUserId: number) {
    let team = await this.prisma.team.findUnique({
      where: {
        id: id,
      },
      include: {
        admins: true,
      },
    });

    if (!team.admins.find((admin) => admin.id === byUserId)) {
      throw new ForbiddenException('Unable to remove admin rights by a non-admin user');
    } else if (team.admins.length === 1) {
      throw new ForbiddenException('Unable to remove last admin');
    }

    return await this.prisma.team.update({
      where: {
        id: id,
      },
      data: {
        admins: {
          disconnect: {
            id: userId,
          },
        },
      },
    });
  }
}
