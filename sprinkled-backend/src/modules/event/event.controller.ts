import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Event } from '@prisma/client';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreateEventDto, UpdateEventDto } from './dto';
import { EventService } from './event.service';

@Controller('events')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('events')
export class EventController {
  constructor(private readonly eventService: EventService) {}

  @Post()
  async createAction(@Body() createEventDto: CreateEventDto, @UserId() userId: number): Promise<Event> {
    return await this.eventService.create(createEventDto, userId);
  }

  @Get()
  async getActions(): Promise<Event[]> {
    return await this.eventService.findAll();
  }

  @Get(':id')
  async getAction(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Event> {
    return await this.eventService.findOne(id);
  }

  @Put(':id')
  async updateAction(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updateEventDto: UpdateEventDto,
  ): Promise<Event> {
    return await this.eventService.update(id, updateEventDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteAction(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.eventService.remove(id);
  }
}
