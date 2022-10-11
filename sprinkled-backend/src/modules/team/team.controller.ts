import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { CreateTeamDto, UpdateTeamDto } from './dto';
import { TeamService } from './team.service';

@Controller('team')
@UseGuards(JwtAccessTokenGuard)
@ApiTags('team')
export class TeamController {
  constructor(private readonly teamService: TeamService) {}

  @Post()
  async createTeam(@Body() createTeamDto: CreateTeamDto, @UserId() userId: number) {
    return await this.teamService.create(createTeamDto, userId);
  }

  @Get()
  async getTeamsForUser(@UserId() userId: number) {
    return await this.teamService.findAllForUser(userId);
  }

  @Get('summary')
  async getTeamsSummaryForUser(@UserId() userId: number) {
    return await this.teamService.findAllForUserSummary(userId);
  }

  @Get(':id')
  async getTeam(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return await this.teamService.findOne(id);
  }

  @Put(':id')
  async updateTeam(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() updateTeamDto: UpdateTeamDto,
  ) {
    return await this.teamService.update(id, updateTeamDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteTeam(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    await this.teamService.remove(id);
  }
}
