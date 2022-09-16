import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AuthModule } from './auth';
import { UserModule } from './user';
import { TeamModule } from './team';
import { PlantModule } from './plant';
import { PlaceModule } from './place';
import { PictureModule } from './picture';
import { PlantEntryModule } from './plant-entry';
import { HttpRequestLoggerMiddleware } from '../middleware';

@Module({
  imports: [AuthModule, UserModule, TeamModule, PlantModule, PlaceModule, PictureModule, PlantEntryModule],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
