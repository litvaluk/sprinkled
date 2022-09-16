import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  await createPlants();
  await createUsers();
  await createTeams();
}

async function createPlants() {
  await prisma.plant.create({
    data: {
      latinName: 'Zamioculcas zamifolia',
      commonName: 'ZZ Plant',
      description:
        'The ZZ plant is a popular houseplant that is easy to care for. It is a slow grower and can tolerate low light conditions.',
      pictureUrl:
        'https://www.thespruce.com/thmb/ps12JCvC8KyGmeQPIa9YWUCPo0M=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/zz-zanzibar-gem-plant-profile-4796783-02-e80e5506091f4dcfb226c5a21718deb6.jpg',
      height: 1.22,
      spread: 0.91,
      minTemp: 12,
      maxTemp: 30,
      leafColor: 'Dark Green',
      bloomColor: '',
      light: 'Strong light',
      zone: 10,
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Ficus benjamina',
      commonName: 'Weeping Fig',
      description: 'The weeping fig is a popular houseplant that is easy to care for.',
      pictureUrl:
        'https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg',
      height: 22.0,
      spread: 10.0,
      minTemp: 10,
      maxTemp: 30,
      leafColor: 'Dark Green',
      bloomColor: '',
      light: 'Full sun',
      zone: 9,
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Disocactus ackermannii',
      commonName: 'Orchid Cactus',
      description: 'The orchid cactus is a popular houseplant that is easy to care for.',
      pictureUrl: 'https://i.pinimg.com/originals/6e/1b/7c/6e1b7ca6173870fb9f1ba4bbc7409aa7.jpg',
      height: 0.3,
      spread: 0.2,
      minTemp: 18,
      maxTemp: 24,
      leafColor: 'Light Green',
      bloomColor: 'Red',
      light: 'Full sun',
      zone: 10,
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Dracaena marginata',
      commonName: 'Madagascar dragon tree',
      description: 'The Madagascar dragon tree is a popular houseplant that is easy to care for.',
      pictureUrl: 'https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg',
      height: 3.05,
      spread: 1.22,
      minTemp: 10,
      maxTemp: 30,
      leafColor: 'Medium Green & Red',
      bloomColor: '',
      light: 'Full sun',
      zone: 4,
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Fragaria x ananassa',
      commonName: 'Garden strawberry ',
      description:
        'The garden strawberry is a widely grown hybrid species of the genus Fragaria, collectively known as the strawberries, which are cultivated worldwide for their fruit.',
      pictureUrl: 'https://www.jahodarnabrozany.cz/user/articles/images/vysadba_jahod.jpg',
      height: 0.3,
      spread: 0.45,
      minTemp: 15,
      maxTemp: 27,
      leafColor: 'Green',
      bloomColor: 'White',
      light: 'Full sun',
      zone: 0,
    },
  });
}

async function createUsers() {
  await prisma.user.create({
    data: {
      username: 'admin',
      password: '$argon2id$v=19$m=4096,t=3,p=1$6q1vWLX+uRCCUC4/saRVJg$iJVMC0DIKUPloYTOq1V2/+gFMb4dTkxb2Doiv8DGHzs', // password
      access_token: '',
      refresh_token: '',
    },
  });

  await prisma.user.create({
    data: {
      username: 'user1',
      password: '$argon2id$v=19$m=4096,t=3,p=1$ud+OxjSz4Ejn5jxIerVslw$e0n9PUbYEZv9z0BMnB+67pyD0KKKZrbRIe+DZUxDQIw', // password
      access_token: '',
      refresh_token: '',
    },
  });

  await prisma.user.create({
    data: {
      username: 'user2',
      password: '$argon2id$v=19$m=4096,t=3,p=1$1fMKD8ZIOImnN/mE35Qhpw$1A4JHG24dPjxGakMHwpAtqBmBkdiP/ZsglYzAB4G95M', // password
      access_token: '',
      refresh_token: '',
    },
  });
}

async function createTeams() {
  await prisma.team.create({
    data: {
      name: 'team1',
      creatorId: 1,
      users: {
        connect: [{ id: 1 }, { id: 2 }],
      },
    },
  });

  await prisma.team.create({
    data: {
      name: 'team2',
      creatorId: 2,
      users: {
        connect: {
          id: 2,
        },
      },
    },
  });
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
