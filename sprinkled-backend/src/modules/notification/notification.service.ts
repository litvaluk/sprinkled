import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { Notification, Provider } from '@parse/node-apn';
import { User } from '@prisma/client';
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
  async handleReminderNotifications() {
    this.logger.log('Handling reminder notifications');
    for (let event of await this._getEventsToRemind()) {
      let usersLinkedToEvent = await this._getUsersLinkedToEvent(event.id);
      await this._sendNotificationToUsers(
        usersLinkedToEvent,
        'Sprinkled',
        'It is time to ' + event.action.type + '.',
        NotificationType.REMINDER,
      );
      await this._markEventAsReminded(event.id);
    }
  }

  async sendEventNotification(eventId: number, triggeredByUserId: number, title: string, body: string) {
    let usersLinkedToEvent = await this._getUsersLinkedToEvent(eventId);
    let usersToBeNotified = usersLinkedToEvent.filter((user) => user.id !== triggeredByUserId);
    await this._sendNotificationToUsers(usersToBeNotified, title, body, NotificationType.EVENT);
  }

  async addPushTokenIfNeeded(pushToken: string, deviceId: string) {
    const pushTokenExists = await this.prisma.pushToken.findFirst({
      where: {
        token: pushToken,
      },
    });

    if (!pushTokenExists) {
      await this.prisma.pushToken.create({
        data: {
          token: pushToken,
          device: {
            connect: {
              deviceId: deviceId,
            },
          },
        },
      });
    }
  }

  async enableReminderNotifications(deviceId: string) {
    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        reminderNotificationsEnabled: true,
      },
    });
  }

  async disableReminderNotifications(deviceId: string) {
    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        reminderNotificationsEnabled: false,
      },
    });
  }

  async enableEventNotifications(deviceId: string) {
    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        eventNotificationsEnabled: true,
      },
    });
  }

  async disableEventNotifications(deviceId: string) {
    await this.prisma.device.update({
      where: {
        deviceId: deviceId,
      },
      data: {
        eventNotificationsEnabled: false,
      },
    });
  }

  private async _sendNotificationToUsers(users: User[], title: string, body: string, notificationType: NotificationType) {
    let userConstraint = {
      device: {
        users: {
          some: {
            id: {
              in: users.map((user) => user.id),
            },
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

  private async _getEventsToRemind() {
    return await this.prisma.event.findMany({
      where: {
        date: {
          lte: new Date(),
        },
        completed: false,
        reminded: false,
      },
      include: {
        action: true,
      },
    });
  }

  private async _getUsersLinkedToEvent(eventId: number) {
    return await this.prisma.user.findMany({
      where: {
        OR: [
          {
            places: {
              some: {
                plantEntries: {
                  some: {
                    events: {
                      some: {
                        id: eventId,
                      },
                    },
                  },
                },
              },
            },
          },
          {
            teams: {
              some: {
                places: {
                  some: {
                    plantEntries: {
                      some: {
                        events: {
                          some: {
                            id: eventId,
                          },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        ],
      },
    });
  }

  private async _markEventAsReminded(eventId: number) {
    await this.prisma.event.update({
      where: {
        id: eventId,
      },
      data: {
        reminded: true,
      },
    });
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
