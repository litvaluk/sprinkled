import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { HttpRequestLoggerMiddleware } from '../middleware';
import { ActionModule } from './action';
import { AuthModule } from './auth';
import { EventModule } from './event';
import { PictureModule } from './picture';
import { PlaceModule } from './place';
import { PlantModule } from './plant';
import { PlantEntryModule } from './plant-entry';
import { ReminderModule } from './reminder';
import { TeamModule } from './team';
import { UserModule } from './user';

@Module({
  imports: [
    AuthModule,
    UserModule,
    TeamModule,
    PlantModule,
    PlaceModule,
    PictureModule,
    PlantEntryModule,
    ActionModule,
    EventModule,
    ReminderModule,
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
