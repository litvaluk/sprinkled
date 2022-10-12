import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Picture } from '@prisma/client';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePictureDto, UpdatePictureDto } from './dto';
import { PictureService } from './picture.service';

@Controller('pictures')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('pictures')
export class PictureController {
  constructor(private readonly pictureService: PictureService) {}

  @Post()
  async createPicture(@Body() createPictureDto: CreatePictureDto, @UserId() userId: number): Promise<Picture> {
    return await this.pictureService.create(createPictureDto, userId);
  }

  @Get()
  async getPictures(): Promise<Picture[]> {
    return await this.pictureService.findAll();
  }

  @Get(':id')
  async getPicture(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Picture> {
    return await this.pictureService.findOne(id);
  }

  @Put(':id')
  async updatePicture(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updatePictureDto: UpdatePictureDto,
  ): Promise<Picture> {
    return await this.pictureService.update(id, updatePictureDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deletePicture(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.pictureService.remove(id);
  }
}
