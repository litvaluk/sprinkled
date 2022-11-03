import Foundation
import SwiftUI

final class AuthViewModel: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var isSignInViewDisplayed = true
	@Published var isProcessing = false
	@Published var errorMessage = ""
	@Published var signInUsername = ""
	@Published var signInPassword = ""
	@Published var signUpUsername = ""
	@Published var signUpEmail = ""
	@Published var signUpPassword = ""
	@Published var signUpPasswordConfirmation = ""
	@Published var isKeyboardPresented = false
	
	@AppStorage("accessToken") var accessToken = ""
	@AppStorage("refreshToken") var refreshToken = ""
	@AppStorage("pushToken") var pushToken = ""
	
	@MainActor
	func signInUser() async {
		errorMessage = ""
		isProcessing = true
		
		do {
			guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
				throw IdentifierForVendorNotFound()
			}
			guard !pushToken.isEmpty else {
				throw InvalidPushToken()
			}
			try await self.api.signIn(signInUsername, signInPassword, deviceId, pushToken)
		} catch {
			errorMessage = "Something went wrong."
		}
		
		isProcessing = false
	}
	
	@MainActor
	func signUpUser() async {
		errorMessage = ""
		isProcessing = true
		
		if (signUpPassword != signUpPasswordConfirmation) {
			errorMessage = "Passwords do not match."
			isProcessing = false
			return
		}
		
		do {
			guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
				throw IdentifierForVendorNotFound()
			}
			guard !pushToken.isEmpty else {
				throw InvalidPushToken()
			}
			try await self.api.signUp(signUpUsername, signUpEmail, signUpPassword, deviceId, pushToken)
		} catch {
			errorMessage = "Something went wrong."
		}
		
		isProcessing = false
	}
	
	func toggleSignIn() {
		isSignInViewDisplayed = !isSignInViewDisplayed
	}
}
