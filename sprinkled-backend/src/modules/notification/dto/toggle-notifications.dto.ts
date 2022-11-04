import { IsUUID } from 'class-validator';

export class ToggleNotificationsDto {
  @IsUUID()
  deviceId: string;
}
