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
}
