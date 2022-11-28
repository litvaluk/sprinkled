import SwiftUI

class ErrorPopupsState: ObservableObject {
	@Published var showConnectionError = false
	@Published var showGenericError = false
	@Published var showSuccess = false
	@Published var successPopupText = ""
	
	@MainActor
	func presentSuccessPopup(text: String) {
		successPopupText = text
		showSuccess = true
	}
}
