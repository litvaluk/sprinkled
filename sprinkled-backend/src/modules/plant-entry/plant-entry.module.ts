import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { ReminderModule } from '../reminder';
import { PlantEntryController } from './plant-entry.controller';
import { PlantEntryService } from './plant-entry.service';

@Module({
  imports: [PrismaModule, ReminderModule],
  controllers: [PlantEntryController],
  providers: [PlantEntryService],
})
export class PlantEntryModule {}
