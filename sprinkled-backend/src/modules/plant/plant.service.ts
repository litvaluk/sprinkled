import { Injectable } from '@nestjs/common';
import { Plant } from '@prisma/client';
import { PrismaService } from 'src/modules/prisma/prisma.service';
import { CreatePlantDto } from './dto/create-plant.dto';
import { UpdatePlantDto } from './dto/update-plant.dto';

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

  async findAll(): Promise<Plant[]> {
    return await this.prisma.plant.findMany();
  }

  async findOne(id: number): Promise<Plant> {
    return await this.prisma.plant.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updatePlantDto: UpdatePlantDto): Promise<Plant> {
    return await this.prisma.plant.update({
      where: {
        id: id,
      },
      data: {
        ...updatePlantDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.plant.delete({
      where: {
        id: id,
      },
    });
  }
}
