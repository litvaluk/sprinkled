import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Place } from '@prisma/client';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePlaceDto, CreateTeamPlaceDto, UpdatePlaceDto } from './dto';
import { PlaceService } from './place.service';

@Controller('places')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('places')
export class PlaceController {
  constructor(private readonly placeService: PlaceService) {}

  @Post('user')
  async createPlaceByUser(@Body() createPlaceDto: CreatePlaceDto, @UserId() userId: number): Promise<Place> {
    return await this.placeService.createByUser(createPlaceDto, userId);
  }

  @Post('team')
  async createPlaceByTeam(@Body() createTeamPlaceDto: CreateTeamPlaceDto): Promise<Place> {
    return await this.placeService.createByTeam(createTeamPlaceDto);
  }

  @Get()
  async getPlaces(): Promise<Place[]> {
    return await this.placeService.findAll();
  }

  @Get(':id')
  async getPlace(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Place> {
    return await this.placeService.findOne(id);
  }

  @Put(':id')
  async updatePlace(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlaceDto: UpdatePlaceDto,
  ): Promise<Place> {
    return await this.placeService.update(id, updatePlaceDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deletePlace(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.placeService.remove(id);
  }
}
