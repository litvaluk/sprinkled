import Foundation

struct Plant: Codable, Identifiable {
	let id: Int
	let latinName: String
	let commonName: String
	let description: String
	let pictureUrl: String
	let height: Double
	let spread: Double
	let minTemp: Int
	let maxTemp: Int
	let leafColor: String
	let bloomColor: String
	let light: String
	let zone: Int
}
