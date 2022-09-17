import { IsDateString, IsInt, IsPositive } from 'class-validator';

export class CreateEventDto {
  @IsDateString()
  date: Date;

  @IsInt()
  @IsPositive()
  plantEntryId: number;

  @IsInt()
  @IsPositive()
  actionId: number;
}
