import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { JwtModule } from '@nestjs/jwt';
import { JwtAccessTokenStrategy, JwtRefreshTokenStrategy } from './strategy';
import { UserModule } from '../user';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
  imports: [UserModule, PrismaModule, JwtModule.register({})],
  providers: [AuthService, JwtAccessTokenStrategy, JwtRefreshTokenStrategy],
  controllers: [AuthController],
})
export class AuthModule {}
