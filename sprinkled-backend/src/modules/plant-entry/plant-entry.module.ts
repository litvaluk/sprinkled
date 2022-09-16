import { Module } from '@nestjs/common';
import { PlantEntryService } from './plant-entry.service';
import { PlantEntryController } from './plant-entry.controller';
import { PrismaModule } from '../prisma';

@Module({
  imports: [PrismaModule],
  controllers: [PlantEntryController],
  providers: [PlantEntryService],
})
export class PlantEntryModule {}
