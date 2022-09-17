import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { PlaceController } from './place.controller';
import { PlaceService } from './place.service';

@Module({
  imports: [PrismaModule],
  controllers: [PlaceController],
  providers: [PlaceService],
})
export class PlaceModule {}
