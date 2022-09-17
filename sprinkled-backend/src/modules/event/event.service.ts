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
    });
  }

  async findAll(): Promise<Event[]> {
    return await this.prisma.event.findMany();
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
