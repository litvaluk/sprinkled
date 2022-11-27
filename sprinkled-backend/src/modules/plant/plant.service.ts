import { Injectable } from '@nestjs/common';
import { Plant } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreatePlantDto } from './dto';

@Injectable()
export class PlantService {
  constructor(private prisma: PrismaService) {}

  async create(createPlantDto: CreatePlantDto): Promise<Plant> {
    return await this.prisma.plant.create({
      data: {
        ...createPlantDto,
      },
    });
  }

  async findAll() {
    return await this.prisma.plant.findMany({
      include: {
        plans: {
          include: {
            reminderBlueprints: {
              include: {
                action: true,
              },
            },
          },
        },
      },
    });
  }

  async findOne(id: number): Promise<Plant> {
    return await this.prisma.plant.findUnique({
      where: {
        id: id,
      },
      include: {
        plans: {
          include: {
            reminderBlueprints: {
              include: {
                action: true,
              },
            },
          },
        },
      },
    });
  }
}
