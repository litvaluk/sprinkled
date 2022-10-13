import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Plant } from '@prisma/client';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePlantDto, UpdatePlantDto } from './dto';
import { PlantService } from './plant.service';

@Controller('plants')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('plants')
export class PlantController {
  constructor(private readonly plantService: PlantService) {}

  @Post()
  async createPlant(@Body() createPlantDto: CreatePlantDto): Promise<Plant> {
    return await this.plantService.create(createPlantDto);
  }

  @Get()
  async getPlants(): Promise<Plant[]> {
    return await this.plantService.findAll();
  }

  @Get(':id')
  async getPlant(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Plant> {
    return await this.plantService.findOne(id);
  }

  @Put(':id')
  async updatePlant(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlantDto: UpdatePlantDto,
  ): Promise<Plant> {
    return await this.plantService.update(id, updatePlantDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deletePlant(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.plantService.remove(id);
  }
}
