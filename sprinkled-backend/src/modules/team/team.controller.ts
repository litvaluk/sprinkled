import { Body, Controller, Delete, Get, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Team } from '@prisma/client';
import { UserId } from 'src/decorator';
import { JwtAccessTokenGuard } from 'src/modules/auth/guard';
import { CreateTeamDto, UpdateTeamDto } from './dto';
import { TeamService } from './team.service';

@Controller('team')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('team')
export class TeamController {
  constructor(private readonly teamService: TeamService) {}

  @Post()
  async createTeam(@Body() createTeamDto: CreateTeamDto, @UserId() userId: number): Promise<Team> {
    return await this.teamService.create(createTeamDto, userId);
  }

  @Get()
  async getTeams(): Promise<Team[]> {
    return await this.teamService.findAll();
  }

  @Get(':id')
  async getTeam(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
  ): Promise<Team> {
    return await this.teamService.findOne(id);
  }

  @Put(':id')
  async updateTeam(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updateTeamDto: UpdateTeamDto,
  ): Promise<Team> {
    return await this.teamService.update(id, updateTeamDto);
  }

  @Delete(':id')
  async deleteTeam(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.teamService.remove(id);
  }
}
