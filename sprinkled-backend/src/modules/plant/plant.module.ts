import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { PlantController } from './plant.controller';
import { PlantService } from './plant.service';

@Module({
  imports: [PrismaModule],
  controllers: [PlantController],
  providers: [PlantService],
})
export class PlantModule {}
