import SwiftUI
import Combine

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
	static let sprinkledPaleGreen = Color("SprinkledPaleGreen")
	static let sprinkledPaleWhite = Color("SprinkledPaleWhite")
}

// remove navigation bar back button text
extension UINavigationController {
	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		navigationBar.topItem?.backButtonDisplayMode = .minimal
	}
}

// JSONDecoder with right date format
extension JSONDecoder {
	static let app: JSONDecoder = {
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return decoder
	}()
}

// for animating when keyboard shows/hides
extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
	Publishers
	  .Merge(
		NotificationCenter
		  .default
		  .publisher(for: UIResponder.keyboardWillShowNotification)
		  .map { _ in true },
		NotificationCenter
		  .default
		  .publisher(for: UIResponder.keyboardWillHideNotification)
		  .map { _ in false })
//	  .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
	  .eraseToAnyPublisher()
  }
}

extension String {
	func capitalizedFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}

	mutating func capitalizeFirstLetter() {
		self = self.capitalizedFirstLetter()
	}
}