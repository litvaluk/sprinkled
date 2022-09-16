import { Controller, Get, Post, Body, Param, Delete, ParseIntPipe, HttpStatus, UseGuards, Put } from '@nestjs/common';
import { PlantService } from './plant.service';
import { CreatePlantDto, UpdatePlantDto } from './dto';
import { Plant } from '@prisma/client';
import { JwtAccessTokenGuard } from 'src/modules/auth/guard';
import { ApiTags } from '@nestjs/swagger';

@Controller('plant')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('plant')
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
  async getPlant(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<Plant> {
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
  async deletePlant(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.plantService.remove(id);
  }
}
