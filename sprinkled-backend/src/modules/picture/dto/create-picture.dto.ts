import { IsInt, IsOptional, IsPositive, IsUrl } from 'class-validator';

export class CreatePictureDto {
  @IsUrl()
  url: string;

  @IsOptional()
  @IsInt()
  @IsPositive()
  plantEntryId: number;
}
