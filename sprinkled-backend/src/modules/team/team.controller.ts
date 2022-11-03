import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Post, Put, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UserId } from '../../decorator';
import { JwtAccessTokenGuard } from '../auth/guard';
import { AddTeamMemberDto, CreateTeamDto, UpdateTeamDto } from './dto';
import { TeamService } from './team.service';

@Controller('teams')
@UseGuards(JwtAccessTokenGuard)
@ApiBearerAuth()
@ApiTags('teams')
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

  @Get(':id/members')
  async getTeamMembers(@Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number) {
    return await this.teamService.getTeamMembers(id);
  }

  @Post(':id/members')
  @HttpCode(HttpStatus.NO_CONTENT)
  async addTeamMember(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Body() addTeamMemberDto: AddTeamMemberDto,
  ) {
    await this.teamService.addTeamMember(id, addTeamMemberDto.userId);
  }

  @Delete(':id/members/:userId')
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeTeamMember(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Param('userId', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) userId: number,
  ) {
    await this.teamService.removeTeamMember(id, userId);
  }

  @Post(':id/members/:userId/give-admin-rights')
  @HttpCode(HttpStatus.NO_CONTENT)
  async giveAdminRights(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Param('userId', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) userId: number,
    @UserId() byUserId: number,
  ) {
    await this.teamService.giveAdminRights(id, userId, byUserId);
  }

  @Post(':id/members/:userId/remove-admin-rights')
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeAdminRights(
    @Param('id', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) id: number,
    @Param('userId', new ParseIntPipe({ errorHttpStatusCode: HttpStatus.BAD_REQUEST })) userId: number,
    @UserId() byUserId: number,
  ) {
    await this.teamService.removeAdminRights(id, userId, byUserId);
  }
}
