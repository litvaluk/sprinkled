import { IsNotEmpty, IsString } from 'class-validator';

export class CreateActionDto {
  @IsString()
  @IsNotEmpty()
  type: string;
}
