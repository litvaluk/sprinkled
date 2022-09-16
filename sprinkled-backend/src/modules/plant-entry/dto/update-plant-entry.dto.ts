import { PartialType } from '@nestjs/mapped-types';
import { IsInt, IsOptional, IsPositive } from 'class-validator';
import { CreatePlantEntryDto } from './create-plant-entry.dto';

export class UpdatePlantEntryDto extends PartialType(CreatePlantEntryDto) {
  @IsOptional()
  @IsInt()
  @IsPositive()
  plantId: number;
}
