import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class LoginDto {
  @IsString()
  @IsNotEmpty()
  username: string;

  @IsString()
  @IsNotEmpty()
  password: string;

  @IsUUID()
  deviceId: string;
}
