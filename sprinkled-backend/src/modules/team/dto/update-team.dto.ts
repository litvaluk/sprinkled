import { PartialType } from '@nestjs/swagger';
import { IsInt, IsOptional, IsPositive } from 'class-validator';
import { CreateTeamDto } from './create-team.dto';

export class UpdateTeamDto extends PartialType(CreateTeamDto) {
  @IsOptional()
  @IsInt()
  @IsPositive()
  creatorId?: number;
}
