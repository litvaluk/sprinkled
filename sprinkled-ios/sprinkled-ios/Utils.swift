class Utils {
	static func calculateFahrenheit(_ celsius: Double) -> Double {
		return celsius * 9 / 5 + 32
	}
	
	static func calculateFeetAndInches(_ meters: Double) -> FeetAndInches {
		let feet = 3.28084 * meters
		let inches = feet.fraction * 12
		return FeetAndInches(feet.whole.toInt()!, inches.whole.toInt()!)
	}
	
	class FeetAndInches {
		let feet: Int
		let inches: Int
		
		init(_ feet: Int, _ inches: Int) {
			self.feet = feet
			self.inches = inches
		}
		
		func toString() -> String {
			return feet != 0 ? String(feet) + "'" + String(inches) + "\"" : String(inches) + "\""
		}
	}
	
	static let actions = [
		Action(id: 1, type: "Water"),
		Action(id: 2, type: "Mist"),
		Action(id: 3, type: "Cut"),
		Action(id: 4, type: "Repot"),
		Action(id: 5, type: "Fertilize"),
		Action(id: 6, type: "Sow"),
		Action(id: 7, type: "Harvest")
	]
}
