import { IsInt, IsNotEmpty, IsOptional, IsPositive, IsString } from 'class-validator';

export class UpdatePlaceDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsOptional()
  @IsInt()
  @IsPositive()
  userId: number;

  @IsOptional()
  @IsInt()
  @IsPositive()
  teamId: number;
}
