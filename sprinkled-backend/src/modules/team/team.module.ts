import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma';
import { TeamController } from './team.controller';
import { TeamService } from './team.service';

@Module({
  imports: [PrismaModule],
  controllers: [TeamController],
  providers: [TeamService],
})
export class TeamModule {}
