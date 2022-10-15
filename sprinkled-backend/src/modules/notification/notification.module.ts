import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { NotificationService } from './notification.service';

@Module({
  imports: [PrismaModule],
  providers: [NotificationService],
  exports: [NotificationService],
})
export class NotificationModule {}
