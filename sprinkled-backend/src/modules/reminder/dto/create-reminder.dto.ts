import { IsDateString, IsInt, IsPositive } from 'class-validator';

export class CreateReminderDto {
  @IsDateString()
  date: Date;

  @IsInt()
  @IsPositive()
  period: number;

  @IsInt()
  @IsPositive()
  plantEntryId: number;

  @IsInt()
  @IsPositive()
  actionId: number;
}
