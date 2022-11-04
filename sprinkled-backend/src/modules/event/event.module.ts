import { Module } from '@nestjs/common';
import { NotificationModule } from '../notification';
import { PrismaModule } from '../prisma';
import { UserModule } from '../user';
import { EventController } from './event.controller';
import { EventService } from './event.service';

@Module({
  imports: [PrismaModule, UserModule, NotificationModule],
  controllers: [EventController],
  providers: [EventService],
})
export class EventModule {}
