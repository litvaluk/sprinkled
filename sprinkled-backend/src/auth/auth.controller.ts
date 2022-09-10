import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto } from './dto';

@Controller('auth')
export class AuthController {
  
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() authDto: AuthDto) {
    return await this.authService.register(authDto);
  }

  @Post('login')
  @HttpCode(200)
  async login(@Body() authDto: AuthDto) {
    return this.authService.login(authDto);
  }

}
