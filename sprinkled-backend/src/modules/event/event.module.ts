import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { EventController } from './event.controller';
import { EventService } from './event.service';

@Module({
  imports: [PrismaModule],
  controllers: [EventController],
  providers: [EventService],
})
export class EventModule {}
