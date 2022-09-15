import { Injectable } from '@nestjs/common';
import { Team } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateTeamDto } from './dto/create-team.dto';
import { UpdateTeamDto } from './dto/update-team.dto';

@Injectable()
export class TeamService {
  constructor(private prisma: PrismaService) {}

  async create(createTeamDto: CreateTeamDto, creatorId: number): Promise<Team> {
    return await this.prisma.team.create({
      data: {
        name: createTeamDto.name,
        creatorId: creatorId,
      },
    });
  }

  async findAll(): Promise<Team[]> {
    return await this.prisma.team.findMany();
  }

  async findOne(id: number): Promise<Team> {
    return await this.prisma.team.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateTeamDto: UpdateTeamDto): Promise<Team> {
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
}
