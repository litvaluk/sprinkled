import { Body, Controller, Get, HttpCode, HttpStatus, Post, Req, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { AuthDto } from './dto';
import { JwtRefreshTokenGuard } from './guard';
import { Request } from 'express';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(
    @Body() authDto: AuthDto,
  ): Promise<{ id: number; username: string; access_token: string; refresh_token: string }> {
    return this.authService.register(authDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() authDto: AuthDto): Promise<{ access_token: string; refresh_token: string }> {
    const tokens = await this.authService.login(authDto);
    return {
      access_token: tokens.accessToken,
      refresh_token: tokens.refreshToken,
    };
  }

  @Get('refresh')
  @UseGuards(JwtRefreshTokenGuard)
  async refresh(@Req() req: Request): Promise<{ access_token: string; refresh_token: string }> {
    const userId = req.user['sub'];
    const refreshToken = req.user['refreshToken'];
    const newTokens = await this.authService.refresh(userId, refreshToken);
    return {
      access_token: newTokens.accessToken,
      refresh_token: newTokens.refreshToken,
    };
  }
}
