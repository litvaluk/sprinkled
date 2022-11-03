import SwiftUI
import Combine
import JWTDecode

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
	static let sprinkledPaleGreen = Color("SprinkledPaleGreen")
	static let sprinkledPaleWhite = Color("SprinkledPaleWhite")
	static let sprinkledGray = Color("SprinkledGray")
	static let sprinkledRed = Color("SprinkledRed")
}

// remove navigation bar back button text
extension UINavigationController {
	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		navigationBar.topItem?.backButtonDisplayMode = .minimal
	}
}

// JSONDecoder with correct date format
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

extension Double {
	func toString() -> String {
		return String(format: "%.1f", self)
	}
}

// enable pop back gesture (for views inside navigation stack with hidden toolbar)
extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}

extension View {
	@ViewBuilder
	func modal<Content: View, Buttons: View>(title: String, showModal: Binding<Bool>, @ViewBuilder content: () -> Content, @ViewBuilder buttons: () -> Buttons) -> some View {
		ZStack {
			self
				.disabled(showModal.wrappedValue)
			if (showModal.wrappedValue) {
				VStack {
					Text(title)
						.font(.title3)
					Spacer()
					content()
						.padding(.vertical, 25)
					Spacer()
					HStack {
						buttons()
					}
				}
				.frame(minWidth: 200, maxWidth: 250)
				.fixedSize(horizontal: false, vertical: true)
				.padding(20)
				.background(Color.sprinkledGray)
				.zIndex(.infinity)
				.cornerRadius(20)
				.shadow(radius: 60)
			}
		}
	}
}

extension String {
	static func placeholder(_ length: Int) -> String {
		String(Array(repeating: "X", count: length))
	}
}

extension Date {
	static var placeholder: Date {
		Date(timeIntervalSince1970: 0)
	}
}

extension Date {
	func encodeToStringForTransfer() -> String {
		self.ISO8601Format(.iso8601(timeZone: .current, includingFractionalSeconds: true)) + "Z"
	}
}

extension View {
	@ViewBuilder
	func redactedShimmering(if condition: @autoclosure () -> Bool) -> some View {
		redacted(reason: condition() ? .placeholder : [])
			.shimmering(active: condition())
	}
	
	@ViewBuilder
	func redactedShimmering() -> some View {
		redactedShimmering(if: true)
	}
}

extension JWT {
	var username: String? {
		return self["username"].string
	}
	
	var userId: Int? {
		return self["sub"].rawValue as? Int
	}
}
