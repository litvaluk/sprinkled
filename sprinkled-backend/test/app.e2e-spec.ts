import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { PrismaClient } from '@prisma/client';
import helmet from 'helmet';
import * as pactum from 'pactum';
import { regex } from 'pactum-matchers';
import { AppModule } from '../src/modules';
import { LoginDto, LogoutDto } from '../src/modules/auth/dto';
import { NotificationService } from '../src/modules/notification/notification.service';
import { CreateUserDto } from '../src/modules/user/dto';

const JWT_TOKEN_REGEX = /^([a-zA-Z0-9_=]+)\.([a-zA-Z0-9_=]+)\.([a-zA-Z0-9_\-\+\/=]*)$/;

const prisma = new PrismaClient();

describe('Sprinkled', () => {
  let app: INestApplication;

  beforeAll(async () => {
    await seedTestDb();

    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(NotificationService)
      .useValue({})
      .compile();

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

  // --------------------------------------------- AUTH --------------------------------------------- //
  describe('Auth', () => {
    describe('Register', () => {
      it('should register a new user', () => {
        const dto: CreateUserDto = {
          username: 'newUser',
          email: 'newUser@gmail.com',
          password: 'passw0rd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(201)
          .expectJsonMatch({
            id: 3,
            username: 'newUser',
            accessToken: regex(JWT_TOKEN_REGEX),
            refreshToken: regex(JWT_TOKEN_REGEX),
          });
      });

      it('should not register a new user with an existing username', () => {
        const dto: CreateUserDto = {
          username: 'newUser',
          email: 'newUser@gmail.com',
          password: 'passw0rd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: ['Username or email already taken.'] });
      });

      it('should not register a new user with an existing email', () => {
        const dto: CreateUserDto = {
          username: 'newUser2',
          email: 'newUser@gmail.com',
          password: 'passw0rd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: ['Username or email already taken.'] });
      });

      it('should not register a new user with short password', () => {
        const dto: CreateUserDto = {
          username: 'newUser2',
          email: 'newUser2@gmail.com',
          password: 'pwd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/register')
          .withJson(dto)
          .expectStatus(400)
          .expectJsonLike({ message: ['Password must be at least 8 characters long and contain at least one letter and one number.'] });
      });
    });

    describe('Login', () => {
      it('should login a user', () => {
        const dto: LoginDto = {
          username: 'newUser',
          password: 'passw0rd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(200)
          .expectJsonMatch({
            accessToken: regex(JWT_TOKEN_REGEX),
            refreshToken: regex(JWT_TOKEN_REGEX),
          })
          .stores('accessTokenAuth', 'accessToken')
          .stores('refreshTokenAuth', 'refreshToken');
      });

      it('should not login a user with wrong password', () => {
        const dto: LoginDto = {
          username: 'newUser',
          password: 'wrong_password',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: ['Invalid username or password.'] });
      });

      it('should not login a nonexistent user', () => {
        const dto: LoginDto = {
          username: 'non_existing_user',
          password: 'passw0rd',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson(dto)
          .expectStatus(403)
          .expectJsonLike({ message: ['Invalid username or password.'] });
      });
    });

    describe('Refresh token', () => {
      it('should refresh a token', () => {
        return pactum
          .spec()
          .post('http://localhost:3001/auth/refresh')
          .withHeaders({ Authorization: 'Bearer $S{refreshTokenAuth}' })
          .expectStatus(200)
          .expectJsonMatch({
            accessToken: regex(JWT_TOKEN_REGEX),
            refreshToken: regex(JWT_TOKEN_REGEX),
          })
          .stores('accessTokenAuth', 'accessToken')
          .stores('refreshTokenAuth', 'refreshToken');
      });

      it('should not refresh a token without authorization header', () => {
        return pactum.spec().post('http://localhost:3001/auth/refresh').expectStatus(401).expectJsonLike({ message: 'Unauthorized' });
      });

      it('should not refresh a token with invalid refresh token', () => {
        return pactum
          .spec()
          .post('http://localhost:3001/auth/refresh')
          .withHeaders({ Authorization: 'Bearer invalid_refresh_token' })
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });

    describe('Logout', () => {
      it('should logout a user', () => {
        return pactum
          .spec()
          .post('http://localhost:3001/auth/logout')
          .withHeaders({ Authorization: 'Bearer $S{accessTokenAuth}' })
          .expectStatus(200);
      });

      it('should not logout a user without authorization header', () => {
        return pactum.spec().post('http://localhost:3001/auth/logout').expectStatus(401).expectJsonLike({ message: 'Unauthorized' });
      });

      it('should not logout a user with invalid access token', () => {
        const dto: LogoutDto = {
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        };
        return pactum
          .spec()
          .post('http://localhost:3001/auth/logout')
          .withHeaders({ Authorization: 'Bearer invalid_access_token' })
          .withJson(dto)
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });
  });

  // --------------------------------------------- USER --------------------------------------------- //
  describe('User', () => {
    beforeAll(async () => {
      await pactum
        .spec()
        .post('http://localhost:3001/auth/login')
        .withJson({
          username: 'user',
          password: 'password',
          deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
        })
        .stores('accessTokenUser', 'accessToken');
    });

    afterAll(async () => {
      await pactum.spec().post('http://localhost:3001/auth/logout');
    });

    describe('Get users', () => {
      it('should get all users', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/users')
          .withHeaders({ Authorization: 'Bearer $S{accessTokenUser}' })
          .expectStatus(200)
          .expectJsonLike([
            {
              id: 1,
              username: 'user',
              email: 'user@gmail.com',
            },
            {
              id: 2,
              username: 'userToBeDeleted',
              email: 'userToBeDeleted@gmail.com',
            },
            {
              id: 3,
              username: 'newUser',
              email: 'newUser@gmail.com',
            },
          ]);
      });

      it('should not get all users without authorization header', () => {
        return pactum.spec().get('http://localhost:3001/users').expectStatus(401).expectJsonLike({ message: 'Unauthorized' });
      });

      it('should not get all users with invalid access token', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/users')
          .withHeaders({ Authorization: 'Bearer invalid_access_token' })
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });

    describe('Get specific user', () => {
      it('should get a specific user', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/users/1')
          .withHeaders({ Authorization: 'Bearer $S{accessTokenUser}' })
          .expectStatus(200)
          .expectJsonLike({
            id: 1,
            username: 'user',
            email: 'user@gmail.com',
          });
      });

      it('should not get a nonexistent user', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/users/4')
          .withHeaders({ Authorization: 'Bearer $S{accessTokenUser}' })
          .expectStatus(404)
          .expectJsonLike({ message: 'Not Found' });
      });

      it('should not get a specific user without authorization header', () => {
        return pactum.spec().get('http://localhost:3001/users/1').expectStatus(401).expectJsonLike({ message: 'Unauthorized' });
      });

      it('should not get a specific user with invalid access token', () => {
        return pactum
          .spec()
          .get('http://localhost:3001/users/1')
          .withHeaders({ Authorization: 'Bearer invalid_access_token' })
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });

    describe('Delete user', () => {
      beforeAll(async () => {
        await pactum
          .spec()
          .post('http://localhost:3001/auth/login')
          .withJson({
            username: 'userToBeDeleted',
            password: 'password',
            deviceId: '06ab9f3b-302e-4cf3-93f1-8549e242caf4',
          })
          .stores('accessTokenUserToBeDeleted', 'accessToken');
      });

      it('should delete a user', () => {
        return pactum
          .spec()
          .delete('http://localhost:3001/users/delete')
          .withHeaders({ Authorization: 'Bearer $S{accessTokenUserToBeDeleted}' })
          .expectStatus(204);
      });

      it('should not delete a user without authorization header', () => {
        return pactum.spec().delete('http://localhost:3001/users/delete').expectStatus(401).expectJsonLike({ message: 'Unauthorized' });
      });

      it('should not delete a user with invalid access token', () => {
        return pactum
          .spec()
          .delete('http://localhost:3001/users/delete')
          .withHeaders({ Authorization: 'Bearer invalid_access_token' })
          .expectStatus(401)
          .expectJsonLike({ message: 'Unauthorized' });
      });
    });
  });
});

async function seedTestDb() {
  await createUsers();
  prisma.$disconnect();
}

async function createUsers() {
  await prisma.user.create({
    data: {
      username: 'user',
      email: 'user@gmail.com',
      password: '$argon2id$v=19$m=4096,t=3,p=1$6q1vWLX+uRCCUC4/saRVJg$iJVMC0DIKUPloYTOq1V2/+gFMb4dTkxb2Doiv8DGHzs', // password
    },
  });
  await prisma.user.create({
    data: {
      username: 'userToBeDeleted',
      email: 'userToBeDeleted@gmail.com',
      password: '$argon2id$v=19$m=4096,t=3,p=1$6q1vWLX+uRCCUC4/saRVJg$iJVMC0DIKUPloYTOq1V2/+gFMb4dTkxb2Doiv8DGHzs', // password
    },
  });
}
