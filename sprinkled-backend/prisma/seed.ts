import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  await createPlants();
  await createUsers();
  await createTeams();
  await createPlaces();
  await createPlantEntries();
  await createPictures();
  await createActions();
  await createEvents();
  await createReminders();
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
      minHeight: 0.4,
      maxHeight: 0.7,
      minSpread: 0.3,
      maxSpread: 0.6,
      minTemp: 12,
      maxTemp: 30,
      water: 'Moderate',
      difficulty: 'Easy',
      light: 'Strong light',
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Ficus benjamina',
      commonName: 'Weeping Fig',
      description: 'The weeping fig is a popular houseplant that is easy to care for.',
      pictureUrl:
        'https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg',
      minHeight: 22.0,
      maxHeight: 30.0,
      minSpread: 10.0,
      maxSpread: 15.0,
      minTemp: 10,
      maxTemp: 30,
      water: 'Moderate',
      difficulty: 'Medium',
      light: 'Full sun',
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Disocactus ackermannii',
      commonName: 'Orchid Cactus',
      description: 'The orchid cactus is a popular houseplant that is easy to care for.',
      pictureUrl: 'https://i.pinimg.com/originals/6e/1b/7c/6e1b7ca6173870fb9f1ba4bbc7409aa7.jpg',
      minHeight: 22.0,
      maxHeight: 30.0,
      minSpread: 10.0,
      maxSpread: 15.0,
      minTemp: 10,
      maxTemp: 30,
      water: 'Moderate',
      difficulty: 'Easy',
      light: 'Full sun',
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Dracaena marginata',
      commonName: 'Madagascar dragon tree',
      description: 'The Madagascar dragon tree is a popular houseplant that is easy to care for.',
      pictureUrl: 'https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg',
      minHeight: 5.0,
      maxHeight: 7.2,
      minSpread: 2.5,
      maxSpread: 3.2,
      minTemp: 10,
      maxTemp: 30,
      water: 'Light',
      difficulty: 'Hard',
      light: 'Full sun',
    },
  });

  await prisma.plant.create({
    data: {
      latinName: 'Fragaria x ananassa',
      commonName: 'Garden strawberry ',
      description:
        'The garden strawberry is a widely grown hybrid species of the genus Fragaria, collectively known as the strawberries, which are cultivated worldwide for their fruit.',
      pictureUrl: 'https://www.jahodarnabrozany.cz/user/articles/images/vysadba_jahod.jpg',
      minHeight: 0.5,
      maxHeight: 1.5,
      minSpread: 2.0,
      maxSpread: 3.0,
      minTemp: 14,
      maxTemp: 25,
      water: 'Moderate',
      difficulty: 'Medium',
      light: 'Full sun',
    },
  });
}

async function createUsers() {
  await prisma.user.create({
    data: {
      username: 'admin',
      email: 'admin@gmail.com',
      password: '$argon2id$v=19$m=4096,t=3,p=1$6q1vWLX+uRCCUC4/saRVJg$iJVMC0DIKUPloYTOq1V2/+gFMb4dTkxb2Doiv8DGHzs', // password
    },
  });

  await prisma.user.create({
    data: {
      username: 'user1',
      email: 'user1@gmail.com',
      password: '$argon2id$v=19$m=4096,t=3,p=1$ud+OxjSz4Ejn5jxIerVslw$e0n9PUbYEZv9z0BMnB+67pyD0KKKZrbRIe+DZUxDQIw', // password
    },
  });

  await prisma.user.create({
    data: {
      username: 'user2',
      email: 'user2@gmail.com',
      password: '$argon2id$v=19$m=4096,t=3,p=1$1fMKD8ZIOImnN/mE35Qhpw$1A4JHG24dPjxGakMHwpAtqBmBkdiP/ZsglYzAB4G95M', // password
    },
  });
}

async function createTeams() {
  await prisma.team.create({
    data: {
      name: 'team1',
      users: {
        connect: [{ id: 1 }, { id: 2 }],
      },
      admins: {
        connect: {
          id: 1,
        },
      },
    },
  });

  await prisma.team.create({
    data: {
      name: 'team2',
      users: {
        connect: {
          id: 2,
        },
      },
      admins: {
        connect: {
          id: 2,
        },
      },
    },
  });
}

async function createPlaces() {
  await prisma.place.create({
    data: {
      name: 'place1',
      userId: 2,
    },
  });

  await prisma.place.create({
    data: {
      name: 'place2',
      userId: 2,
    },
  });

  await prisma.place.create({
    data: {
      name: 'place3',
      userId: 3,
    },
  });
}

async function createPlantEntries() {
  await prisma.plantEntry.create({
    data: {
      name: 'plantEntry1',
      plantId: 1,
      creatorId: 2,
      placeId: 1,
      headerPictureUrl: 'https://cdn.shopify.com/s/files/1/0461/9809/6024/products/Zanz-17.jpg?v=1636259067&width=1946',
    },
  });

  await prisma.plantEntry.create({
    data: {
      name: 'plantEntry2',
      plantId: 1,
      creatorId: 3,
      placeId: 2,
      headerPictureUrl: 'https://cdn.shopify.com/s/files/1/0461/9809/6024/products/Zanz-17.jpg?v=1636259067&width=1946',
    },
  });

  await prisma.plantEntry.create({
    data: {
      name: 'plantEntry3',
      plantId: 2,
      creatorId: 2,
      placeId: 1,
      headerPictureUrl: 'https://cdn.shopify.com/s/files/1/0461/9809/6024/products/Zanz-17.jpg?v=1636259067&width=1946',
    },
  });
}

async function createPictures() {
  await prisma.picture.create({
    data: {
      userId: 2,
      plantEntryId: 1,
      url: 'https://images.squarespace-cdn.com/content/v1/5637bd4be4b06d0197275f73/1585727885128-CB50IK9ADQ24G4GTSJWV/10%2522+ZZ.jpg?format=1000w',
    },
  });

  await prisma.picture.create({
    data: {
      userId: 2,
      plantEntryId: 1,
      url: 'https://media.istockphoto.com/photos/zanzibar-gem-or-zz-plant-on-the-windowsill-picture-id1219720875?k=20&m=1219720875&s=612x612&w=0&h=PmhEAJSKX1atRrnIOEyyVr0wNFWghFA9dlkkhxTW7eo=',
    },
  });

  await prisma.picture.create({
    data: {
      userId: 3,
      plantEntryId: 3,
      url: 'https://www.nkz.cz/sites/default/files/public/styles/content_lg/public/2019-12/shutterstock1328790263.jpg?itok=MXMLYCdf',
    },
  });
}

async function createActions() {
  await prisma.action.create({
    data: {
      type: 'Water',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Mist',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Cut',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Repot',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Fertilize',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Sow',
    },
  });

  await prisma.action.create({
    data: {
      type: 'Harvest',
    },
  });
}

async function createEvents() {
  await prisma.event.create({
    data: {
      date: new Date('2022-09-17T11:00:00'),
      actionId: 1,
      plantEntryId: 1,
      userId: 2,
    },
  });

  await prisma.event.create({
    data: {
      date: new Date('2022-09-17T12:00:00'),
      actionId: 2,
      plantEntryId: 2,
      userId: 2,
    },
  });

  await prisma.event.create({
    data: {
      date: new Date('2022-09-18T10:00:00'),
      actionId: 1,
      plantEntryId: 1,
      userId: 3,
    },
  });
}

async function createReminders() {
  await prisma.reminder.create({
    data: {
      date: new Date('2022-09-17T11:00:00'),
      actionId: 1,
      plantEntryId: 2,
      creatorId: 2,
      period: 10,
    },
  });

  await prisma.reminder.create({
    data: {
      date: new Date('2022-09-17T12:00:00'),
      actionId: 1,
      plantEntryId: 1,
      creatorId: 3,
      period: 30,
    },
  });

  await prisma.reminder.create({
    data: {
      date: new Date('2022-09-17T13:00:00'),
      actionId: 3,
      plantEntryId: 1,
      creatorId: 3,
      period: 600,
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
