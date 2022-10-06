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
