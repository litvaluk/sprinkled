import Foundation

struct Plant: Codable, Identifiable {
	let id: Int
	let latinName: String
	let commonName: String
	let description: String
	let pictureUrl: String
	let difficulty: String
	let water: String
	let minHeight: Double
	let maxHeight: Double
	let minSpread: Double
	let maxSpread: Double
	let minTemp: Int
	let maxTemp: Int
	let light: String
}
