import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { TeamModule } from './team/team.module';
import { HttpRequestLoggerMiddleware } from './middleware';

@Module({
  imports: [PrismaModule, AuthModule, UserModule, TeamModule],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
