import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import helmet from 'helmet';
import * as pactum from 'pactum';
import { regex } from 'pactum-matchers';
import { AppModule } from '../src/modules';
import { LoginDto } from '../src/modules/auth/dto';
import { CreateUserDto } from '../src/modules/user/dto';

const JWT_TOKEN_REGEX = /^([a-zA-Z0-9_=]+)\.([a-zA-Z0-9_=]+)\.([a-zA-Z0-9_\-\+\/=]*)$/;

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
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(201)
          .expectJsonMatch({
            id: 1,
            username: 'user',
            access_token: regex(JWT_TOKEN_REGEX),
            refresh_token: regex(JWT_TOKEN_REGEX),
          });
      });
      it('should not register a new user with an existing username', () => {
        const dto: CreateUserDto = { username: 'user', password: 'password' };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: 'Username already taken' });
      });
      it('should not register a new user with short password', () => {
        const dto: CreateUserDto = { username: 'user2', password: 'pwd' };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(400)
          .expectJsonLike({ message: ['password must be longer than or equal to 8 characters'] });
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
          .expectJsonMatch({
            access_token: regex(JWT_TOKEN_REGEX),
            refresh_token: regex(JWT_TOKEN_REGEX),
          })
          .stores('accessToken', 'access_token')
          .stores('refreshToken', 'refresh_token');
      });
      it('should not login a user with wrong password', () => {
        const dto: LoginDto = { username: 'user', password: 'wrong_password' };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: 'Invalid username or password' });
      });
      it('should not login a nonexistent user', () => {
        const dto: LoginDto = { username: 'non_existing_user', password: 'password' };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: 'Invalid username or password' });
      });
    });
    describe('Refresh token', () => {
      it('should refresh a token', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/auth/refresh')
          .withHeaders({ Authorization: 'Bearer $S{refreshToken}' })
          .expectStatus(200)
          .expectJsonMatch({
            access_token: regex(JWT_TOKEN_REGEX),
            refresh_token: regex(JWT_TOKEN_REGEX),
          })
          .stores('accessToken', 'access_token')
          .stores('refreshToken', 'access_token');
      });
      it('should not refresh a token without authorization header', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/auth/refresh')
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
      it('should not refresh a token with invalid refresh token', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/auth/refresh')
          .withHeaders({ Authorization: 'Bearer invalid_refresh_token' })
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });
  });
});
