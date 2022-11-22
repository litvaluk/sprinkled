import { IsEmail, IsString, IsUUID, Matches, MaxLength, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @MinLength(4, { message: 'Username must be at least 4 characters long.' })
  @MaxLength(20, { message: 'Username must be at most 20 characters long.' })
  username: string;

  @IsEmail({}, { message: 'Invalid email address.' })
  email: string;

  @IsString()
  @Matches(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, {
    message: 'Password must be at least 8 characters long and contain at least one letter and one number.',
  })
  password: string;

  @IsUUID()
  deviceId: string;
}
