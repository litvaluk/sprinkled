import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Event } from '@prisma/client';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { NotificationService } from '../notification';
import { UserService } from '../user';
import { CreateEventDto, UpdateEventDto } from './dto';
import { EventService } from './event.service';

@Controller('events')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('events')
export class EventController {
  constructor(
    private readonly eventService: EventService,
    private readonly userService: UserService,
    private readonly notificationService: NotificationService,
  ) {}

  private actionTypePastTenses = new Map<string, string>([
    ['Water', 'watered'],
    ['Mist', 'misted'],
    ['Cut', 'cut'],
    ['Repot', 'repotted'],
    ['Fertilize', 'fertilized'],
    ['Sow', 'sowed'],
    ['Harvest', 'harvested'],
  ]);

  @Post()
  async createEvent(@Body() createEventDto: CreateEventDto, @UserId() userId: number): Promise<Event> {
    let newEvent = await this.eventService.create(createEventDto, userId);
    let user = await this.userService.findOneSafe(userId);
    await this.notificationService.sendEventNotification(
      newEvent.id,
      user.id,
      'User ' +
        user.username +
        'has just added a new ' +
        newEvent.action.type.toLowerCase() +
        ' event to the' +
        newEvent.plantEntry.name +
        '.',
    );
    return newEvent;
  }

  @Get()
  async getEvents(@Query('completed') completed?: string): Promise<Event[]> {
    if (completed === undefined) {
      return await this.eventService.findAll();
    } else if (completed === 'true') {
      return await this.eventService.findCompleted();
    } else if (completed === 'false') {
      return await this.eventService.findUncompleted();
    } else {
      throw new BadRequestException('Invalid value for query parameter completed');
    }
  }

  @Get(':id')
  async getEvent(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Event> {
    return await this.eventService.findOne(id);
  }

  @Put(':id')
  async updateEvent(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updateEventDto: UpdateEventDto,
  ): Promise<Event> {
    return await this.eventService.update(id, updateEventDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteEvent(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.eventService.remove(id);
  }

  @Post(':id/complete')
  @HttpCode(HttpStatus.NO_CONTENT)
  async completeEvent(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @UserId() userId: number,
  ) {
    let event = await this.eventService.complete(id, userId);
    let user = await this.userService.findOneSafe(userId);
    await this.notificationService.sendEventNotification(
      id,
      userId,
      'User ' + user.username + ' has just ' + this.actionTypePastTenses.get(event.action.type) + ' the ' + event.plantEntry.name + '.',
    );
  }
}
