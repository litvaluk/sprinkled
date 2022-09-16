import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AuthModule } from './auth';
import { UserModule } from './user';
import { TeamModule } from './team';
import { PlantModule } from './plant';
import { PlaceModule } from './place';
import { HttpRequestLoggerMiddleware } from '../middleware';

@Module({
  imports: [AuthModule, UserModule, TeamModule, PlantModule, PlaceModule],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
