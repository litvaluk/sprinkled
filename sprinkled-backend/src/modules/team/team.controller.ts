import { Controller, Get, Post, Body, Param, Delete, ParseIntPipe, HttpStatus, Put, UseGuards } from '@nestjs/common';
import { TeamService } from './team.service';
import { CreateTeamDto, UpdateTeamDto } from './dto';
import { ApiTags } from '@nestjs/swagger';
import { JwtAccessTokenGuard } from 'src/modules/auth/guard';
import { UserId } from 'src/decorator';
import { Team } from '@prisma/client';

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
