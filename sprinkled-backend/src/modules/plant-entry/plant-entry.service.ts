import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma';
import { CreatePlantEntryDto } from './dto/create-plant-entry.dto';
import { UpdatePlantEntryDto } from './dto/update-plant-entry.dto';

@Injectable()
export class PlantEntryService {
  constructor(private prisma: PrismaService) {}

  async create(createPlantEntryDto: CreatePlantEntryDto, userId: number) {
    return await this.prisma.plantEntry.create({
      data: {
        ...createPlantEntryDto,
        creatorId: userId,
      },
    });
  }

  async findAll() {
    return await this.prisma.plantEntry.findMany();
  }

  async findOne(id: number) {
    return await this.prisma.plantEntry.findUnique({
      where: {
        id: id,
      },
      include: {
        plant: {
          select: {
            commonName: true,
          },
        },
        events: {
          where: {
            completed: true,
          },
          include: {
            action: true,
            user: {
              select: {
                id: true,
                username: true,
                email: true,
              },
            },
            plantEntry: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
        reminders: {
          include: {
            action: true,
          },
        },
        pictures: {
          include: {
            user: {
              select: {
                id: true,
                username: true,
                email: true,
              },
            },
          },
        },
      },
    });
  }

  async update(id: number, updatePlantEntryDto: UpdatePlantEntryDto) {
    return await this.prisma.plantEntry.update({
      where: {
        id: id,
      },
      data: {
        ...updatePlantEntryDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.plantEntry.delete({
      where: {
        id: id,
      },
    });
  }
}
