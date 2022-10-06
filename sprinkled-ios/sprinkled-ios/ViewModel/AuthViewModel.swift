import Foundation
import SwiftUI

final class AuthViewModel: ObservableObject {
	@Published var isSignInViewDisplayed = true
	@Published var isProcessing = false
	@Published var errorMessage = ""
	@Published var signInEmail = ""
	@Published var signInPassword = ""
	@Published var signUpEmail = ""
	@Published var signUpPassword = ""
	@Published var signUpPasswordConfirmation = ""
	
	@AppStorage("accessTokenValue") var accessTokenValue = ""
	@AppStorage("refreshTokenValue") var refreshTokenValue = ""
	
	func signInUser() {
		errorMessage = ""
		isProcessing = true
		
		// TODO
		accessTokenValue = "accesTokenValue"
		refreshTokenValue = "refreshTokenValue"
		
		isProcessing = false
	}
	
	func signUpUser() {
		errorMessage = ""
		isProcessing = true
		
		if (signUpPassword != signUpPasswordConfirmation) {
			errorMessage = "Passwords do not match."
			isProcessing = false
			return
		}
		
		// TODO
		accessTokenValue = "accesTokenValue"
		refreshTokenValue = "refreshTokenValue"
		
		isProcessing = false
	}
	
	func toggleSignIn() {
		isSignInViewDisplayed = !isSignInViewDisplayed
	}
}
