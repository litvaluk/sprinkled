import { Injectable } from '@nestjs/common';
import { Event } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreateEventDto, UpdateEventDto } from './dto';

@Injectable()
export class EventService {
  constructor(private prisma: PrismaService) {}

  async create(createEventDto: CreateEventDto, userId: number): Promise<Event> {
    return await this.prisma.event.create({
      data: {
        ...createEventDto,
        userId: userId,
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
      },
    });
  }

  async findAll(): Promise<Event[]> {
    return await this.prisma.event.findMany();
  }

  async findUncompleted(): Promise<Event[]> {
    return await this.prisma.event.findMany({
      where: {
        completed: false,
      },
    });
  }

  async findCompleted(): Promise<Event[]> {
    return await this.prisma.event.findMany({
      where: {
        completed: true,
      },
    });
  }

  async findOne(id: number): Promise<Event> {
    return await this.prisma.event.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateEventDto: UpdateEventDto): Promise<Event> {
    return await this.prisma.event.update({
      where: {
        id: id,
      },
      data: {
        ...updateEventDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.event.delete({
      where: {
        id: id,
      },
    });
  }
}
