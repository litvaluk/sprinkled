import { Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { UserSafe } from './types';
import { UserService } from './user.service';

@Controller('user')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('user')
export class UserController {
  constructor(private userService: UserService) {}

  @Get()
  async getUsers(): Promise<UserSafe[]> {
    return this.userService.findAllSafe();
  }

  @Get(':id')
  async getUser(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number): Promise<UserSafe> {
    return this.userService.findOneSafe(id);
  }

  @Delete('delete')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteUser(@UserId() userId: number) {
    return this.userService.delete(userId);
  }
}
