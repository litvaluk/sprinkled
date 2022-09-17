import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { PlantEntryController } from './plant-entry.controller';
import { PlantEntryService } from './plant-entry.service';

@Module({
  imports: [PrismaModule],
  controllers: [PlantEntryController],
  providers: [PlantEntryService],
})
export class PlantEntryModule {}
