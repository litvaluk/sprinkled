import { Body, Controller, HttpCode, HttpStatus, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { UserId } from '../../decorator';
import { CreateUserDto } from '../user/dto';
import { AuthService } from './auth.service';
import { LoginDto } from './dto';
import { JwtAccessTokenGuard, JwtRefreshTokenGuard } from './guard';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.authService.register(createUserDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto) {
    const tokens = await this.authService.login(loginDto);
    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  @Post('refresh')
  @UseGuards(JwtRefreshTokenGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async refresh(@Req() req: Request) {
    const userId = req.user['sub'];
    const refreshToken = req.user['refreshToken'];
    const newTokens = await this.authService.refresh(userId, refreshToken);
    return {
      accessToken: newTokens.accessToken,
      refreshToken: newTokens.refreshToken,
    };
  }

  @Post('logout')
  @UseGuards(JwtAccessTokenGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async logout(@UserId() userId: number) {
    await this.authService.logout(userId);
  }
}
