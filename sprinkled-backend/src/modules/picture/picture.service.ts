import { Injectable } from '@nestjs/common';
import { Picture } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreatePictureDto } from './dto';
import { UpdatePictureDto } from './dto/update-picture.dto';

@Injectable()
export class PictureService {
  constructor(private prisma: PrismaService) {}

  async create(createPictureDto: CreatePictureDto, userId: number): Promise<Picture> {
    return await this.prisma.picture.create({
      data: {
        ...createPictureDto,
        userId: userId,
      },
    });
  }

  async findAll(): Promise<Picture[]> {
    return await this.prisma.picture.findMany();
  }

  async findOne(id: number): Promise<Picture> {
    return await this.prisma.picture.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updatePictureDto: UpdatePictureDto): Promise<Picture> {
    return await this.prisma.picture.update({
      where: {
        id: id,
      },
      data: {
        ...updatePictureDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.picture.delete({
      where: {
        id: id,
      },
    });
  }
}
