import { Body, Controller, Delete, Get, HttpStatus, Param, ParseIntPipe, Post, Put } from '@nestjs/common';
import { Place } from '@prisma/client';
import { CreatePlaceDto, UpdatePlaceDto } from './dto';
import { PlaceService } from './place.service';

@Controller('place')
export class PlaceController {
  constructor(private readonly placeService: PlaceService) {}

  @Post()
  async createPlace(@Body() createPlantDto: CreatePlaceDto): Promise<Place> {
    return await this.placeService.create(createPlantDto);
  }

  @Get()
  async getPlaces(): Promise<Place[]> {
    return await this.placeService.findAll();
  }

  @Get(':id')
  async getPlace(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<Place> {
    return await this.placeService.findOne(id);
  }

  @Put(':id')
  async updatePlace(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlantDto: UpdatePlaceDto,
  ): Promise<Place> {
    return await this.placeService.update(id, updatePlantDto);
  }

  @Delete(':id')
  async deletePlace(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.placeService.remove(id);
  }
}
