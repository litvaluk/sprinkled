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

  @IsNumber()
  @IsPositive()
  height: number;

  @IsNumber()
  @IsPositive()
  spread: number;

  @IsInt()
  minTemp: number;

  @IsInt()
  maxTemp: number;

  @IsString()
  leafColor: string;

  @IsString()
  bloomColor: string;

  @IsString()
  light: string;

  @IsInt()
  zone: number;
}
