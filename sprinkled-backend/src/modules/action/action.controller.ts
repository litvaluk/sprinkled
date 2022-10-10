import { Body, Controller, Delete, Get, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Action } from '@prisma/client';
import { JwtAccessTokenGuard } from '../auth/guard';
import { ActionService } from './action.service';
import { CreateActionDto, UpdateActionDto } from './dto';

@Controller('action')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('action')
export class ActionController {
  constructor(private readonly actionService: ActionService) {}

  @Post()
  async createAction(@Body() createActionDto: CreateActionDto): Promise<Action> {
    return await this.actionService.create(createActionDto);
  }

  @Get()
  async getActions(): Promise<Action[]> {
    return await this.actionService.findAll();
  }

  @Get(':id')
  async getAction(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<Action> {
    return await this.actionService.findOne(id);
  }

  @Put(':id')
  async updateAction(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updateActionDto: UpdateActionDto,
  ): Promise<Action> {
    return await this.actionService.update(id, updateActionDto);
  }

  @Delete(':id')
  async deleteAction(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.actionService.remove(id);
  }
}
