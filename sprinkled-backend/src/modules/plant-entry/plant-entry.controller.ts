import { Body, Controller, Delete, Get, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PlantEntry } from '@prisma/client';
import { UserId } from 'src/decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePlantEntryDto } from './dto/create-plant-entry.dto';
import { UpdatePlantEntryDto } from './dto/update-plant-entry.dto';
import { PlantEntryService } from './plant-entry.service';

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
