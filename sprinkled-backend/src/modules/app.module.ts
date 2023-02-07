import { HttpException, MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { SentryInterceptor, SentryModule } from '@ntegral/nestjs-sentry';
import { HttpRequestLoggerMiddleware } from '../middleware';
import { AuthModule } from './auth';
import { EventModule } from './event';
import { NotificationModule } from './notification';
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
    EventModule,
    ReminderModule,
    NotificationModule,
    ScheduleModule.forRoot(),
    SentryModule.forRoot({
      dsn: process.env.SENTRY_DSN,
      environment: process.env.SENTRY_ENV,
      debug: false,
      tracesSampleRate: 1.0,
    }),
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useFactory: () =>
        new SentryInterceptor({
          filters: [
            {
              type: HttpException,
              filter: (exception: HttpException) => 500 > exception.getStatus(), // Only report 500 errors
            },
          ],
        }),
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(HttpRequestLoggerMiddleware).forRoutes('*');
  }
}
