import { PartialType } from '@nestjs/mapped-types';
import { IsInt, IsOptional, IsPositive } from 'class-validator';
import { CreateReminderDto } from './create-reminder.dto';

export class UpdateReminderDto extends PartialType(CreateReminderDto) {
  @IsOptional()
  @IsInt()
  @IsPositive()
  userId: number;
}
