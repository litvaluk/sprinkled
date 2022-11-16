import { IsInt, IsOptional, IsPositive, IsString, IsUrl, MaxLength, MinLength } from 'class-validator';

export class CreatePlantEntryDto {
  @IsString()
  @MinLength(3, { message: 'Name must be at least 3 characters long.' })
  @MaxLength(20)
  name: string;

  @IsInt()
  @IsPositive()
  placeId: number;

  @IsInt()
  @IsPositive()
  plantId: number;

  @IsUrl()
  @IsOptional()
  headerPictureUrl: string;
}
