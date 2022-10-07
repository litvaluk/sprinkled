import SwiftUI

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
}

// remove navigation bar back button text
extension UINavigationController {
	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		navigationBar.topItem?.backButtonDisplayMode = .minimal
	}
}

extension JSONDecoder {
	static let app: JSONDecoder = {
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return decoder
	}()
}
