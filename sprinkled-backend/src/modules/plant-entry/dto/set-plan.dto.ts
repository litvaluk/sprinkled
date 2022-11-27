import { IsInt, IsPositive, Max, Min } from 'class-validator';

export class SetPlanDto {
  @IsInt()
  @IsPositive()
  planId: number;

  @IsInt()
  @Min(0)
  @Max(23)
  preferredHour: number;

  @IsInt()
  @Min(0)
  @Max(59)
  preferredMinute: number;
}
