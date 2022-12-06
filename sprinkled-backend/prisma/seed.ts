import { PrismaClient } from '@prisma/client';
import plants from './plants.json';

const prisma = new PrismaClient();

async function main() {
  await createActions();
  await createPlants();
  await createUsers();
  await createTeams();
  await createPlaces();
  await createPlantEntries();
  await createPictures();
  await createEvents();
  await createReminders();
}

async function createPlants() {
  plants.forEach(async (plant) => {
    let createdPlant = await prisma.plant.create({
      data: plant,
    });

    let period: number;
    if (createdPlant.water === 'Low') {
      period = 14;
    } else if (createdPlant.water === 'Moderate') {
      period = 8;
    } else {
      period = 5;
    }

    let plan = await prisma.plan.create({
      data: {
        name: 'Just watering',
        plantId: createdPlant.id,
      },
    });

    await prisma.reminderBlueprint.create({
      data: {
        actionId: 1,
        planId: plan.id,
        period: period,
      },
    });

    plan = await prisma.plan.create({
      data: {
        name: 'Complete care',
        plantId: createdPlant.id,
      },
    });

    await prisma.reminderBlueprint.create({
      data: {
        actionId: 1,
        planId: plan.id,
        period: period,
      },
    });

    await prisma.reminderBlueprint.create({
      data: {
        actionId: 3,
        planId: plan.id,
        period: 90,
      },
    });

    await prisma.reminderBlueprint.create({
      data: {
        actionId: 4,
        planId: plan.id,
        period: 180,
      },
    });

    await prisma.reminderBlueprint.create({
      data: {
        actionId: 5,
        planId: plan.id,
        period: 14,
      },
    });
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
