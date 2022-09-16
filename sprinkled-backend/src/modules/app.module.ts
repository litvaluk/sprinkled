import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { PrismaModule } from './prisma';
import { AuthModule } from './auth';
import { UserModule } from './user';
import { TeamModule } from './team';
import { PlantModule } from './plant';
import { HttpRequestLoggerMiddleware } from '../middleware';

@Module({
  imports: [PrismaModule, AuthModule, UserModule, TeamModule, PlantModule],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
