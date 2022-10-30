import { Injectable } from '@nestjs/common';
import { Reminder } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreateReminderDto, UpdateReminderDto } from './dto';

@Injectable()
export class ReminderService {
  constructor(private prisma: PrismaService) {}

  async create(createReminderDto: CreateReminderDto, userId: number): Promise<Reminder> {
    return await this.prisma.reminder.create({
      data: {
        ...createReminderDto,
        creatorId: userId,
      },
      include: {
        action: true,
      },
    });
  }

  async findAll(): Promise<Reminder[]> {
    return await this.prisma.reminder.findMany({
      include: {
        action: true,
        plantEntry: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });
  }

  async findOne(id: number): Promise<Reminder> {
    return await this.prisma.reminder.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateReminderDto: UpdateReminderDto): Promise<Reminder> {
    return await this.prisma.reminder.update({
      where: {
        id: id,
      },
      data: {
        ...updateReminderDto,
      },
    });
  }

  async remove(id: number) {
    await this.prisma.reminder.delete({
      where: {
        id: id,
      },
    });
  }
}
