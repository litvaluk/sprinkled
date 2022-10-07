import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import * as argon2 from 'argon2';
import { Request } from 'express';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { UserService } from '../../user';

@Injectable()
export class JwtAccessTokenStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(private userService: UserService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: process.env.JWT_ACCESS_TOKEN_SECRET,
      passReqToCallback: true,
    });
  }

  async validate(req: Request, payload: any) {
    const accessToken = req.get('Authorization').replace('Bearer', '').trim();

    const user = await this.userService.findOne(payload.sub);
    if (!user || !argon2.verify(user.accessToken, accessToken)) {
      throw new UnauthorizedException();
    }

    return payload;
  }
}
