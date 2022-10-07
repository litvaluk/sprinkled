import { Body, Controller, Get, HttpCode, HttpStatus, Post, Req, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { CreateUserDto } from '../user/dto';
import { AuthService } from './auth.service';
import { LoginDto } from './dto';
import { JwtRefreshTokenGuard } from './guard';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(
    @Body() createUserDto: CreateUserDto,
  ): Promise<{ id: number; username: string; accessToken: string; refreshToken: string }> {
    return this.authService.register(createUserDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto): Promise<{ accessToken: string; refreshToken: string }> {
    const tokens = await this.authService.login(loginDto);
    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  @Get('refresh')
  @UseGuards(JwtRefreshTokenGuard)
  async refresh(@Req() req: Request): Promise<{ accessToken: string; refreshToken: string }> {
    const userId = req.user['sub'];
    const refreshToken = req.user['refreshToken'];
    const newTokens = await this.authService.refresh(userId, refreshToken);
    return {
      accessToken: newTokens.accessToken,
      refreshToken: newTokens.refreshToken,
    };
  }
}
