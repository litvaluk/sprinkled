import SwiftUI
import Combine
import JWTDecode

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
	static let sprinkledPaleGreen = Color("SprinkledPaleGreen")
	static let sprinkledPaleWhite = Color("SprinkledPaleWhite")
	static let sprinkledGray = Color("SprinkledGray")
	static let sprinkledRed = Color("SprinkledRed")
	
	init(hex: String) {
		let scanner = Scanner(string: hex)
		var rgbValue: UInt64 = 0
		scanner.scanHexInt64(&rgbValue)
		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff
		self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
	}
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
		dateFormatter.timeZone = .gmt
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return decoder
	}()
}

extension String {
	func capitalizedFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizedFirstLetter()
	}
	
	static func placeholder(_ length: Int) -> String {
		String(Array(repeating: "X", count: length))
	}
}

extension Double {
	func toString() -> String {
		return String(format: "%.1f", self)
	}
	
	func toInt() -> Int? {
		if self >= Double(Int.min) && self < Double(Int.max) {
			return Int(self)
		} else {
			return nil
		}
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

extension Date {
	static var placeholder: Date {
		Date(timeIntervalSince1970: 0)
	}
	
	func encodeToStringForTransfer() -> String {
		self.ISO8601Format(.iso8601(timeZone: .gmt, includingFractionalSeconds: true)) + "Z"
	}
	
	func zeroSeconds() -> Date {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
		return calendar.date(from: dateComponents)!
	}
	
	func toString(_ dateFormat: DateFormat, timeZone: TimeZone = .current) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = timeZone
		switch(dateFormat) {
		case .HHmm:
			dateFormatter.dateFormat = "HH:mm"
		case .MMMdy:
			dateFormatter.dateFormat = "MMM d, y"
		case .MMMd:
			dateFormatter.dateFormat = "MMM d"
		}
		return dateFormatter.string(from: self)
	}
	
	enum DateFormat {
		case HHmm
		case MMMdy
		case MMMd
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
	
	// for animating when keyboard shows/hides
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

extension JWT {
	var username: String? {
		return self["username"].string
	}
	
	var userId: Int? {
		return self["sub"].rawValue as? Int
	}
}

extension FloatingPoint {
	var whole: Self { modf(self).0 }
	var fraction: Self { modf(self).1 }
}

extension Binding where Value == Bool {
	/// Creates a binding by mapping an optional value to a `Bool` that is
	/// `true` when the value is non-`nil` and `false` when the value is `nil`.
	///
	/// When the value of the produced binding is set to `false` the value
	/// of `bindingToOptional`'s `wrappedValue` is set to `nil`.
	///
	/// Setting the value of the produce binding to `true` does nothing and
	/// logs a message.
	///
	/// - parameter bindingToOptional: A `Binding` to an optional value, used to calculate the `wrappedValue`.
	public init<Wrapped>(mappedTo bindingToOptional: Binding<Wrapped?>) {
		self.init(
			get: { bindingToOptional.wrappedValue != nil },
			set: { newValue in
				if (!newValue) {
					bindingToOptional.wrappedValue = nil
				} else {
					print("Attempted to set the value of the produce binding to 'true'. Setting the value of the produce binding to 'true' does nothing.")
				}
			}
		)
	}
}

extension Binding {
	/// Returns a binding by mapping this binding's value to a `Bool` that is
	/// `true` when the value is non-`nil` and `false` when the value is `nil`.
	public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
		return Binding<Bool>(mappedTo: self)
	}
}
