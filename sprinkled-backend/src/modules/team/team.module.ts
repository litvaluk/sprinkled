import { Module } from '@nestjs/common';
import { TeamService } from './team.service';
import { PrismaModule } from 'src/modules/prisma';
import { TeamController } from './team.controller';

@Module({
  imports: [PrismaModule],
  controllers: [TeamController],
  providers: [TeamService],
})
export class TeamModule {}
