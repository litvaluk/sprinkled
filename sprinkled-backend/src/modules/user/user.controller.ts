import { Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { UserService } from './user.service';

@Controller('users')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('users')
export class UserController {
  constructor(private userService: UserService) {}

  @Get()
  async getUsers() {
    return this.userService.findAllSafe();
  }

  @Get(':id')
  async getUser(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return this.userService.findOneSafe(id);
  }

  @Delete('delete')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteUser(@UserId() userId: number) {
    return this.userService.delete(userId);
  }
}
