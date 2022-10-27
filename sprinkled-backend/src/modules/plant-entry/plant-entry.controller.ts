import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePlantEntryDto } from './dto/create-plant-entry.dto';
import { UpdatePlantEntryDto } from './dto/update-plant-entry.dto';
import { PlantEntryService } from './plant-entry.service';

@Controller('plant-entries')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('plant-entries')
export class PlantEntryController {
  constructor(private readonly plantEntryService: PlantEntryService) {}

  @Post()
  async createPlantEntry(@Body() createPlantEntryDto: CreatePlantEntryDto, @UserId() userId: number) {
    return await this.plantEntryService.create(createPlantEntryDto, userId);
  }

  @Get()
  async getPlantEntries() {
    return await this.plantEntryService.findAll();
  }

  @Get(':id')
  async getPlantEntry(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return await this.plantEntryService.findOne(id);
  }

  @Put(':id')
  async updatePlantEntry(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlantEntryDto: UpdatePlantEntryDto,
  ) {
    return await this.plantEntryService.update(id, updatePlantEntryDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deletePlantEntry(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.plantEntryService.remove(id);
  }
}
