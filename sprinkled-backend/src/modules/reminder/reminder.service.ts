import { Injectable } from '@nestjs/common';
import { Reminder } from '@prisma/client';
import { PrismaService } from '../prisma';
import { CreateReminderDto, UpdateReminderDto } from './dto';

@Injectable()
export class ReminderService {
  constructor(private prisma: PrismaService) {}

  async create(createReminderDto: CreateReminderDto, userId: number): Promise<Reminder> {
    let createdReminder = await this.prisma.reminder.create({
      data: {
        ...createReminderDto,
        creatorId: userId,
      },
      include: {
        action: true,
      },
    });

    if (createReminderDto.period > 0) {
      let events = [];
      for (let i = 0; i < 10; i++) {
        events.push({
          date: this._addDays(createdReminder.date, i * createdReminder.period),
          userId: undefined,
          plantEntryId: createReminderDto.plantEntryId,
          actionId: createReminderDto.actionId,
          completed: false,
          reminded: false,
          reminderId: createdReminder.id,
        });
      }
      await this.prisma.event.createMany({
        data: events,
      });
    } else {
      await this.prisma.event.create({
        data: {
          date: createdReminder.date,
          userId: undefined,
          plantEntryId: createReminderDto.plantEntryId,
          actionId: createReminderDto.actionId,
          completed: false,
          reminded: false,
          reminderId: createdReminder.id,
        },
      });
    }

    return createdReminder;
  }

  async findAll(): Promise<Reminder[]> {
    return await this.prisma.reminder.findMany();
  }

  async findOne(id: number): Promise<Reminder> {
    return await this.prisma.reminder.findUnique({
      where: {
        id: id,
      },
    });
  }

  async update(id: number, updateReminderDto: UpdateReminderDto): Promise<Reminder> {
    let updatedReminder = await this.prisma.reminder.update({
      where: {
        id: id,
      },
      data: {
        ...updateReminderDto,
      },
      include: {
        action: true,
      },
    });

    await this.prisma.event.deleteMany({
      where: {
        reminderId: id,
        completed: false,
      },
    });

    if (updatedReminder.period > 0) {
      let events = [];
      for (let i = 0; i < 10; i++) {
        events.push({
          date: this._addDays(updatedReminder.date, i * updatedReminder.period),
          userId: undefined,
          plantEntryId: updatedReminder.plantEntryId,
          actionId: updatedReminder.actionId,
          completed: false,
          reminded: false,
          reminderId: id,
        });
      }
      await this.prisma.event.createMany({
        data: events,
      });
    } else {
      await this.prisma.event.create({
        data: {
          date: updatedReminder.date,
          userId: undefined,
          plantEntryId: updatedReminder.plantEntryId,
          actionId: updatedReminder.actionId,
          completed: false,
          reminded: false,
          reminderId: id,
        },
      });
    }

    return updatedReminder;
  }

  async remove(id: number) {
    await this.prisma.event.deleteMany({
      where: {
        reminderId: id,
        completed: false,
      },
    });
    await this.prisma.reminder.delete({
      where: {
        id: id,
      },
    });
  }

  private _addDays(date: Date, days: number) {
    let result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }
}
