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
        plantEntry: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });
  }

  async findAll(): Promise<Event[]> {
    return await this.prisma.event.findMany({
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
    });
  }

  async findUncompleted(): Promise<Event[]> {
    return await this.prisma.event.findMany({
      where: {
        completed: false,
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
    });
  }

  async findCompleted(): Promise<Event[]> {
    return await this.prisma.event.findMany({
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
    });
  }

  async remove(id: number) {
    await this.prisma.event.delete({
      where: {
        id: id,
      },
    });
  }

  async complete(id: number, userId: number) {
    await this.prisma.event.update({
      where: {
        id: id,
      },
      data: {
        date: new Date(),
        completed: true,
        userId: userId,
      },
    });
    await this._removeLinkedReminderIfNeeded(id);
  }

  private async _removeLinkedReminderIfNeeded(eventId: number) {
    let reminder = await this.prisma.reminder.findFirst({
      where: {
        events: {
          some: {
            id: eventId,
          },
        },
      },
    });
    if (reminder && reminder.period === 0) {
      await this.prisma.reminder.delete({
        where: {
          id: reminder.id,
        },
      });
    }
  }
}
