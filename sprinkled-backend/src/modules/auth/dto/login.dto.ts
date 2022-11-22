import { IsString, IsUUID } from 'class-validator';

export class LoginDto {
  @IsString()
  username: string;

  @IsString()
  password: string;

  @IsUUID()
  deviceId: string;
}
