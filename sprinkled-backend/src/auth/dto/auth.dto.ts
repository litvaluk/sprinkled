import { IsString, MinLength, MaxLength, Matches } from 'class-validator';

export class AuthDto {
  
  @IsString()
  @MinLength(4)
  @MaxLength(20)
  username: string;

  @IsString()
  @MinLength(8)
  @MaxLength(20)
  password: string

}