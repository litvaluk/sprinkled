import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { Notification, Provider } from '@parse/node-apn';
import { PrismaService } from '../prisma';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);
  private apnProvider: Provider;

  constructor(private prisma: PrismaService) {
    var options = {
      token: {
        key: '-----BEGIN PRIVATE KEY-----\n' + process.env.APNS_KEY_STRING + '\n-----END PRIVATE KEY-----',
        keyId: process.env.APNS_KEY_ID,
        teamId: process.env.APNS_TEAM_ID,
      },
      production: process.env.APNS_PRODUCTION === 'true',
    };
    this.apnProvider = new Provider(options);
  }

  @Cron('0 * * * * *') // every minute
  handleReminderNotifications() {
    this.logger.log('Handling reminder notifications');
    // TODO: implement
  }

  async sendNotification(userId: number, title: string, body: string, notificationType: NotificationType) {
    let userConstraint = {
      device: {
        users: {
          some: {
            id: userId,
          },
        },
      },
    };

    let notificationsEnabledConstraint;
    if (notificationType === NotificationType.REMINDER) {
      notificationsEnabledConstraint = {
        device: {
          reminderNotificationsEnabled: true,
        },
      };
    } else if (notificationType === NotificationType.EVENT) {
      notificationsEnabledConstraint = {
        device: {
          reminderNotificationsEnabled: true,
        },
      };
    } else {
      throw new Error('Invalid notification type');
    }

    let pushTokens = await this.prisma.pushToken.findMany({
      where: {
        AND: [userConstraint, notificationsEnabledConstraint],
      },
    });
    for (let pushToken of pushTokens) {
      let notification = this._createNotification(title, body);
      await this._sendNotification(notification, pushToken.token);
    }
  }

  private async _sendNotification(notification: Notification, pushToken: string) {
    let result = await this.apnProvider.send(notification, pushToken);
    if (result.sent) {
      this.logger.log(`Sent notification to [${pushToken}]`);
    } else {
      this.logger.warn(`Failed to send notification to [${pushToken}]`);
    }
  }

  private _createNotification(title: string, body: string) {
    var notification = new Notification();
    notification.topic = process.env.APNS_BUNDLE_ID;
    notification.aps = {
      alert: {
        title: title,
        body: body,
      },
    };
    notification.sound = 'default';
    return notification;
  }
}

export enum NotificationType {
  REMINDER,
  EVENT,
}
