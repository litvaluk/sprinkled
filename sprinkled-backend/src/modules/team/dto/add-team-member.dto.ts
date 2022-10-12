import { IsInt, IsPositive } from 'class-validator';

export class AddTeamMemberDto {
  @IsInt()
  @IsPositive()
  userId: number;
}
