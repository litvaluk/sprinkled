import { PartialType } from '@nestjs/swagger';
import { IsInt, IsOptional, IsPositive, IsString, MaxLength, MinLength } from 'class-validator';
import { CreateTeamDto } from './create-team.dto';

export class UpdateTeamDto {
  @IsOptional()
  @IsString()
  @MinLength(3)
  @MaxLength(20)
  name?: string;

  @IsOptional()
  @IsInt()
  @IsPositive()
  creatorId?: number;
}
