import { IsDateString, IsInt, IsPositive, Min } from 'class-validator';

export class CreateReminderDto {
  @IsDateString()
  date: Date;

  @IsInt()
  @Min(0)
  period: number;

  @IsInt()
  @IsPositive()
  plantEntryId: number;

  @IsInt()
  @IsPositive()
  actionId: number;
}
