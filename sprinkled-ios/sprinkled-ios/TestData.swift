import Foundation

struct TestData {
	static let plants = [
		Plant(
			id: 1,
			latinName: "Zamioculcas zamifolia",
			commonName: "ZZ Plant",
			description:
				"The ZZ plant is a popular houseplant that is easy to care for. It is a slow grower and can tolerate low light conditions.",
			pictureUrl:
				"https://www.thespruce.com/thmb/ps12JCvC8KyGmeQPIa9YWUCPo0M=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/zz-zanzibar-gem-plant-profile-4796783-02-e80e5506091f4dcfb226c5a21718deb6.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 0.4,
			maxHeight: 0.7,
			minSpread: 0.3,
			maxSpread: 0.6,
			minTemp: 12,
			maxTemp: 30,
			light: "Strong light"
		),
		Plant(
			id: 2,
			latinName: "Ficus benjamina",
			commonName: "Weeping Fig",
			description: "The weeping fig is a popular houseplant that is easy to care for.",
			pictureUrl:
				"https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg",
			difficulty: "Medium",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		),
		Plant(
			id: 3,
			latinName: "Disocactus ackermannii",
			commonName: "Orchid Cactus",
			description: "The orchid cactus is a popular houseplant that is easy to care for.",
			pictureUrl: "https://i.pinimg.com/originals/6e/1b/7c/6e1b7ca6173870fb9f1ba4bbc7409aa7.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		),
		Plant(
			id: 4,
			latinName: "Zamioculcas zamifolia",
			commonName: "ZZ Plant",
			description:
				"The ZZ plant is a popular houseplant that is easy to care for. It is a slow grower and can tolerate low light conditions.",
			pictureUrl:
				"https://www.thespruce.com/thmb/ps12JCvC8KyGmeQPIa9YWUCPo0M=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/zz-zanzibar-gem-plant-profile-4796783-02-e80e5506091f4dcfb226c5a21718deb6.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 0.4,
			maxHeight: 0.7,
			minSpread: 0.3,
			maxSpread: 0.6,
			minTemp: 12,
			maxTemp: 30,
			light: "Strong light"
		),
		Plant(
			id: 5,
			latinName: "Ficus benjamina",
			commonName: "Weeping Fig",
			description: "The weeping fig is a popular houseplant that is easy to care for.",
			pictureUrl:
				"https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg",
			difficulty: "Medium",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		),
		Plant(
			id: 6,
			latinName: "Disocactus ackermannii",
			commonName: "Orchid Cactus",
			description: "The orchid cactus is a popular houseplant that is easy to care for.",
			pictureUrl: "https://i.pinimg.com/originals/6e/1b/7c/6e1b7ca6173870fb9f1ba4bbc7409aa7.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		),
		Plant(
			id: 7,
			latinName: "Zamioculcas zamifolia",
			commonName: "ZZ Plant",
			description:
				"The ZZ plant is a popular houseplant that is easy to care for. It is a slow grower and can tolerate low light conditions.",
			pictureUrl:
				"https://www.thespruce.com/thmb/ps12JCvC8KyGmeQPIa9YWUCPo0M=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/zz-zanzibar-gem-plant-profile-4796783-02-e80e5506091f4dcfb226c5a21718deb6.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 0.4,
			maxHeight: 0.7,
			minSpread: 0.3,
			maxSpread: 0.6,
			minTemp: 12,
			maxTemp: 30,
			light: "Strong light"
		),
		Plant(
			id: 8,
			latinName: "Ficus benjamina",
			commonName: "Weeping Fig",
			description: "The weeping fig is a popular houseplant that is easy to care for.",
			pictureUrl:
				"https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg",
			difficulty: "Medium",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		),
		Plant(
			id: 9,
			latinName: "Disocactus ackermannii",
			commonName: "Orchid Cactus",
			description: "The orchid cactus is a popular houseplant that is easy to care for.",
			pictureUrl: "https://i.pinimg.com/originals/6e/1b/7c/6e1b7ca6173870fb9f1ba4bbc7409aa7.jpg",
			difficulty: "Easy",
			water: "Moderate",
			minHeight: 22.0,
			maxHeight: 30.0,
			minSpread: 10.0,
			maxSpread: 15.0,
			minTemp: 10,
			maxTemp: 30,
			light: "Full sun"
		)
	]
	
	static let teamSummaries = [
		TeamSummary(id: 0, name: "Personal", places: [
			TeamSummaryPlace(id: 1, name: "Place 1", plantEntries: [
				TeamSummaryPlantEntry(id: 1, name: "Plant 1", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 2, name: "Plant 2", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 3, name: "Plant 3", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
			]),
			TeamSummaryPlace(id: 2, name: "Place 2", plantEntries: [
				TeamSummaryPlantEntry(id: 4, name: "Plant 4", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 5, name: "Plant 5", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
			])
		]),
		TeamSummary(id: 1, name: "Team 1", places: [
			TeamSummaryPlace(id: 3, name: "Place 3", plantEntries: [
				TeamSummaryPlantEntry(id: 6, name: "Plant 6", headerPictureUrl: nil),
				TeamSummaryPlantEntry(id: 7, name: "Plant 7", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 8, name: "Plant 8", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 9, name: "Plant 9", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
			]),
		]),
		TeamSummary(id: 2, name: "Team 2", places: [
			TeamSummaryPlace(id: 4, name: "Place 4", plantEntries: [
				TeamSummaryPlantEntry(id: 10, name: "Plant 10", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
			]),
			TeamSummaryPlace(id: 5, name: "Place 5", plantEntries: [
				TeamSummaryPlantEntry(id: 11, name: "Plant 11", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
				TeamSummaryPlantEntry(id: 12, name: "Plant 12", headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg"),
			]),
			TeamSummaryPlace(id: 6, name: "Place 6", plantEntries: [])
		])
	]
	
	static let teams = [
		Team(id: 1, name: "Team 1"),
		Team(id: 2, name: "Team 2"),
		Team(id: 3, name: "Team 3"),
	]
	
	static let places = [
		Place(id: 1, name: "Place 1", teamId: nil, userId: 1),
		Place(id: 2, name: "Place 2", teamId: nil, userId: 1),
		Place(id: 3, name: "Place 3", teamId: 1, userId: nil),
		Place(id: 4, name: "Place 4", teamId: 2, userId: nil)
	]
	
	static let teamMembers = [
		TeamMember(id: 1, username: "User1", isAdmin: true),
		TeamMember(id: 2, username: "User2", isAdmin: false),
		TeamMember(id: 3, username: "User3", isAdmin: false),
		TeamMember(id: 4, username: "User4", isAdmin: true),
	]
	
	static let users = [
		User(id: 1, username: "User1", email: "user1@gmail.com"),
		User(id: 2, username: "User2", email: "user2@gmail.com")
	]
	
	static let actions = [
		Action(id: 1, type: "Water"),
		Action(id: 2, type: "Mist"),
		Action(id: 3, type: "Fertilize"),
		Action(id: 4, type: "Harvest"),
		Action(id: 5, type: "Cut"),
		Action(id: 6, type: "Sow"),
		Action(id: 7, type: "Repot")
	]

	static let events = [
		Event(id: 1, date: Date(), userId: 1, plantEntryId: 1, actionId: 1, user: users[0], action: actions[0], completed: true, reminded: nil, reminderId: nil, plantEntry: Event.PlantEntryIdAndName(id: 1, name: "Plant entry 1")),
		Event(id: 2, date: Date(), userId: 2, plantEntryId: 1, actionId: 2, user: users[1], action: actions[1], completed: true, reminded: nil, reminderId: nil, plantEntry: Event.PlantEntryIdAndName(id: 1, name: "Plant entry 1")),
		Event(id: 3, date: Date(timeIntervalSince1970: 1696327200), userId: 1, plantEntryId: 1, actionId: 2, user: users[0], action: actions[2], completed: false, reminded: nil, reminderId: nil, plantEntry: Event.PlantEntryIdAndName(id: 1, name: "Plant entry 1"))
	]

	static let reminders = [
		Reminder(id: 1, date: Date(timeIntervalSince1970: 1696165200), period: 0, actionId: 1, plantEntryId: 1, creatorId: 1, action: actions[0]),
		Reminder(id: 2, date: Date(timeIntervalSince1970: 1696327200), period: 2, actionId: 2, plantEntryId: 1, creatorId: 2, action: actions[1]),
		Reminder(id: 3, date: Date(timeIntervalSince1970: 1696676400), period: 5, actionId: 1, plantEntryId: 1, creatorId: 1, action: actions[1]),
		Reminder(id: 4, date: Date(timeIntervalSince1970: 1696327200), period: 0, actionId: 1, plantEntryId: 1, creatorId: 1, action: actions[1]),
		Reminder(id: 5, date: Date(timeIntervalSince1970: 1696860000), period: 0, actionId: 3, plantEntryId: 1, creatorId: 2, action: actions[1])
	]

	static let pictures = [
		Picture(id: 1, url: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg", createdAt: Date(), userId: 1, plantEntryId: 1, user: TestData.users[0]),
		Picture(id: 2, url: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg", createdAt: Date(), userId: 1, plantEntryId: 1, user: TestData.users[0]),
	]
	
	static let plantEntries = [
		PlantEntry(id: 1, name: "Plant entry 1", createdAt: Date(), creatorId: 1, placeId: 1, plantId: 1, headerPictureUrl: "https://www.plantvine.com/plants/Dracaena-Marginata-Cane-2.jpg", events: events, reminders: reminders, pictures: pictures)
	]
}
