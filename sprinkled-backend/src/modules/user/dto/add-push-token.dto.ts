import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class AddPushTokenDto {
  @IsUUID()
  deviceId: string;

  @IsString()
  @IsNotEmpty()
  pushToken: string;
}
