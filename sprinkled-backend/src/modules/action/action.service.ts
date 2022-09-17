import { Injectable } from '@nestjs/common';
import { Action } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreateActionDto, UpdateActionDto } from './dto';

@Injectable()
export class ActionService {
  constructor(private prisma: PrismaService) {}

  async create(createActionDto: CreateActionDto): Promise<Action> {
    return await this.prisma.action.create({
      data: {
        ...createActionDto,
      },
    });
  }

  async findAll(): Promise<Action[]> {
    return await this.prisma.action.findMany();
  }

  async findOne(id: number): Promise<Action> {
    return await this.prisma.action.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateActionDto: UpdateActionDto): Promise<Action> {
    return await this.prisma.action.update({
      where: {
        id: id,
      },
      data: {
        ...updateActionDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.action.delete({
      where: {
        id: id,
      },
    });
  }
}
