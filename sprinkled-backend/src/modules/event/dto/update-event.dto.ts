import { PartialType } from '@nestjs/mapped-types';
import { IsInt, IsOptional, IsPositive } from 'class-validator';
import { CreateEventDto } from './create-event.dto';

export class UpdateEventDto extends PartialType(CreateEventDto) {
  @IsOptional()
  @IsInt()
  @IsPositive()
  userId: number;
}
