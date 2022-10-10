import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreateReminderDto, UpdateReminderDto } from './dto';
import { ReminderService } from './reminder.service';

@Controller('reminder')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('reminder')
export class ReminderController {
  constructor(private readonly reminderService: ReminderService) {}

  @Post()
  async createReminder(@Body() createReminderDto: CreateReminderDto, @UserId() userId: number) {
    return await this.reminderService.create(createReminderDto, userId);
  }

  @Get()
  async getReminders() {
    return await this.reminderService.findAll();
  }

  @Get(':id')
  async getReminder(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return await this.reminderService.findOne(id);
  }

  @Put(':id')
  async updateReminder(
    @Body() updateReminderDto: UpdateReminderDto,
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ) {
    return await this.reminderService.update(id, updateReminderDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteReminder(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.reminderService.remove(id);
  }
}
