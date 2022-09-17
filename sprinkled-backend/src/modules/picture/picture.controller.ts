import { Body, Controller, Delete, Get, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Picture } from '@prisma/client';
import { UserId } from 'src/decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreatePictureDto, UpdatePictureDto } from './dto';
import { PictureService } from './picture.service';

@Controller('picture')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('picture')
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
  async getPicture(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<Picture> {
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
  async deletePicture(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.pictureService.remove(id);
  }
}
