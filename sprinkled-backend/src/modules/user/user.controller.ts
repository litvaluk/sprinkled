import { Controller, Get, HttpStatus, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
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
  async getUser(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<UserSafe> {
    return this.userService.findOneSafe(id);
  }
}
