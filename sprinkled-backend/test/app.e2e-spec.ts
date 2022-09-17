import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import helmet from 'helmet';
import * as pactum from 'pactum';
import { AppModule } from '../src/modules';
import { LoginDto } from '../src/modules/auth/dto';
import { CreateUserDto } from '../src/modules/user/dto';

describe('Sprinkled', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    app.use(helmet());
    app.enableCors();
    await app.init();
    await app.listen(3001);
  });

  afterAll(() => {
    app.close();
  });

  describe('Auth', () => {
    describe('Register', () => {
      it('should register a new user', () => {
        const dto: CreateUserDto = { username: 'user', password: 'password' };
        return pactum.spec().post('http://localhost:3001/auth/register').withJson(dto).expectStatus(201);
      });
    });
    describe('Login', () => {
      it('should login a user', () => {
        const dto: LoginDto = { username: 'user', password: 'password' };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(200)
          .stores('accessToken', 'access_token')
          .stores('refreshToken', 'refresh_token');
      });
    });
    describe('Refresh token', () => {
      it('should refresh a token', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/auth/refresh')
          .withHeaders({ Authorization: 'Bearer $S{refreshToken}' })
          .expectStatus(200)
          .stores('accessToken', 'access_token')
          .stores('refreshToken', 'access_token');
      });
    });
  });
});
