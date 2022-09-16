import { Controller, Get, Post, Body, Param, Delete, UseGuards, Put, ParseIntPipe, HttpStatus } from '@nestjs/common';
import { PlantEntryService } from './plant-entry.service';
import { CreatePlantEntryDto } from './dto/create-plant-entry.dto';
import { UpdatePlantEntryDto } from './dto/update-plant-entry.dto';
import { JwtAccessTokenGuard } from '../auth/guard';
import { ApiTags } from '@nestjs/swagger';
import { UserId } from 'src/decorator';
import { PlantEntry } from '@prisma/client';

@Controller('plant-entry')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('plant-entry')
export class PlantEntryController {
  constructor(private readonly plantEntryService: PlantEntryService) {}

  @Post()
  async createPlantEntry(
    @Body() createPlantEntryDto: CreatePlantEntryDto,
    @UserId() userId: number,
  ): Promise<PlantEntry> {
    return await this.plantEntryService.create(createPlantEntryDto, userId);
  }

  @Get()
  async getPlantEntries(): Promise<PlantEntry[]> {
    return await this.plantEntryService.findAll();
  }

  @Get(':id')
  async getPlantEntry(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<PlantEntry> {
    return await this.plantEntryService.findOne(id);
  }

  @Put(':id')
  async updatePlantEntry(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlantEntryDto: UpdatePlantEntryDto,
  ): Promise<PlantEntry> {
    return await this.plantEntryService.update(id, updatePlantEntryDto);
  }

  @Delete(':id')
  async deletePlantEntry(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.plantEntryService.remove(id);
  }
}
