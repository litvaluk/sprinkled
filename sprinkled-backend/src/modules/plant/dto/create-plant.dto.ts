import { IsInt, IsNumber, IsPositive, IsString } from 'class-validator';

export class CreatePlantDto {
  @IsString()
  latinName: string;

  @IsString()
  commonName: string;

  @IsString()
  description: string;

  @IsString()
  pictureUrl: string;

  @IsString()
  difficulty: string;

  @IsString()
  water: string;

  @IsNumber()
  @IsPositive()
  minHeight: number;

  @IsNumber()
  @IsPositive()
  maxHeight: number;

  @IsNumber()
  @IsPositive()
  minSpread: number;

  @IsNumber()
  @IsPositive()
  maxSpread: number;

  @IsInt()
  minTemp: number;

  @IsInt()
  maxTemp: number;

  @IsString()
  light: string;
}
