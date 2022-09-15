import { IsString, MaxLength, MinLength } from 'class-validator';

export class CreateTeamDto {
  @IsString()
  @MinLength(3)
  @MaxLength(20)
  name: string;
}
