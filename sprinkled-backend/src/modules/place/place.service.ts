import { Injectable } from '@nestjs/common';
import { Place } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreatePlaceDto, CreateTeamPlaceDto, UpdatePlaceDto } from './dto';

@Injectable()
export class PlaceService {
  constructor(private prisma: PrismaService) {}

  async createByUser(createPlaceDto: CreatePlaceDto, userId: number): Promise<Place> {
    return await this.prisma.place.create({
      data: {
        ...createPlaceDto,
        userId: userId,
      },
    });
  }

  async createByTeam(createTeamPlaceDto: CreateTeamPlaceDto): Promise<Place> {
    return await this.prisma.place.create({
      data: {
        ...createTeamPlaceDto,
      },
    });
  }

  async findAll(): Promise<Place[]> {
    return await this.prisma.place.findMany();
  }

  async findOne(id: number): Promise<Place> {
    return await this.prisma.place.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updatePlaceDto: UpdatePlaceDto): Promise<Place> {
    return await this.prisma.place.update({
      where: {
        id: id,
      },
      data: {
        ...updatePlaceDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.place.delete({
      where: {
        id: id,
      },
    });
  }
}
