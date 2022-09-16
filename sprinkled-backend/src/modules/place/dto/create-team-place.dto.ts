import { IsInt, IsNotEmpty, IsPositive, IsString } from 'class-validator';

export class CreateTeamPlaceDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsInt()
  @IsPositive()
  teamId: number;
}
