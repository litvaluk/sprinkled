import { Body, Controller, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAccessTokenGuard } from '../auth/guard';
import { ToggleNotificationsDto } from './dto';
import { NotificationService } from './notification.service';

@Controller('notifications')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('notifications')
export class NotificationController {
  constructor(private notificationService: NotificationService) {}

  @Post('enable-reminder-notifications')
  @HttpCode(HttpStatus.NO_CONTENT)
  async enableReminderNotifications(@Body() toggleNotificationsDto: ToggleNotificationsDto) {
    this.notificationService.enableReminderNotifications(toggleNotificationsDto.deviceId);
  }

  @Post('disable-reminder-notifications')
  @HttpCode(HttpStatus.NO_CONTENT)
  async disableReminderNotifications(@Body() toggleNotificationsDto: ToggleNotificationsDto) {
    this.notificationService.disableReminderNotifications(toggleNotificationsDto.deviceId);
  }

  @Post('enable-event-notifications')
  @HttpCode(HttpStatus.NO_CONTENT)
  async enableEventNotifications(@Body() toggleNotificationsDto: ToggleNotificationsDto) {
    this.notificationService.enableEventNotifications(toggleNotificationsDto.deviceId);
  }

  @Post('disable-event-notifications')
  @HttpCode(HttpStatus.NO_CONTENT)
  async disableEventNotifications(@Body() toggleNotificationsDto: ToggleNotificationsDto) {
    this.notificationService.disableEventNotifications(toggleNotificationsDto.deviceId);
  }
}
