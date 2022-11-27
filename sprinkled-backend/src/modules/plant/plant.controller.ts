import { Controller, Get, HttpStatus, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Plant } from '@prisma/client';
import { JwtAccessTokenGuard } from '../auth/guard';
import { PlantService } from './plant.service';

@Controller('plants')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('plants')
export class PlantController {
  constructor(private readonly plantService: PlantService) {}

  @Get()
  async getPlants(): Promise<Plant[]> {
    return await this.plantService.findAll();
  }

  @Get(':id')
  async getPlant(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Plant> {
    return await this.plantService.findOne(id);
  }
}
