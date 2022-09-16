import { IsInt, IsPositive, IsString, MaxLength, MinLength } from 'class-validator';

export class CreatePlantEntryDto {
  @IsString()
  @MinLength(3)
  @MaxLength(20)
  name: string;

  @IsInt()
  @IsPositive()
  placeId: number;

  @IsInt()
  @IsPositive()
  plantId: number;
}
