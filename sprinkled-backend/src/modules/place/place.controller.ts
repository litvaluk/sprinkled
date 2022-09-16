import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Put,
  ParseIntPipe,
  HttpStatus,
} from '@nestjs/common';
import { PlaceService } from './place.service';
import { JwtAccessTokenGuard } from '../auth/guard';
import { ApiTags } from '@nestjs/swagger';
import { CreatePlaceDto, CreateTeamPlaceDto, UpdatePlaceDto } from './dto';
import { UserId } from 'src/decorator';
import { Place } from '@prisma/client';

@Controller('place')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('place')
export class PlaceController {
  constructor(private readonly placeService: PlaceService) {}

  @Post('user')
  async createByUser(@Body() createPlaceDto: CreatePlaceDto, @UserId() userId: number): Promise<Place> {
    return await this.placeService.createByUser(createPlaceDto, userId);
  }

  @Post('team')
  async createByTeam(@Body() createTeamPlaceDto: CreateTeamPlaceDto): Promise<Place> {
    return await this.placeService.createByTeam(createTeamPlaceDto);
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
  async updateTeam(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePlaceDto: UpdatePlaceDto,
  ): Promise<Place> {
    return await this.placeService.update(id, updatePlaceDto);
  }

  @Delete(':id')
  async deleteTeam(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return await this.placeService.remove(id);
  }
}
