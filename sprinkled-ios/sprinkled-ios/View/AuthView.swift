import SwiftUI

struct AuthView: View {
	@StateObject var viewModel: AuthViewModel
	
	var body: some View {
		VStack (spacing: 8) {
			if (!viewModel.isKeyboardPresented || viewModel.isSignInViewDisplayed) {
				Text("Sprinkled")
					.font(.system(size: 48))
					.fontWeight(.medium)
					.padding()
			}
			if (viewModel.isSignInViewDisplayed) {
				TextField("Username", text: $viewModel.signInUsername)
					.textFieldStyle(SprinkledTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
				SecureField("Password", text: $viewModel.signInPassword)
					.textFieldStyle(SprinkledTextFieldStyle())
			} else {
				TextField("Username", text: $viewModel.signUpUsername)
					.textFieldStyle(SprinkledTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
				TextField("Email", text: $viewModel.signUpEmail)
					.textFieldStyle(SprinkledTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					.keyboardType(.emailAddress)
				SecureField("Password", text: $viewModel.signUpPassword)
					.textFieldStyle(SprinkledTextFieldStyle())
				SecureField("Confirm password", text: $viewModel.signUpPasswordConfirmation)
					.textFieldStyle(SprinkledTextFieldStyle())
			}
			
			if !viewModel.errorMessage.isEmpty {
				Text("\(viewModel.errorMessage)")
					.multilineTextAlignment(.center)
					.foregroundColor(.red)
			}
			Spacer()
			if (!viewModel.isSignInViewDisplayed) {
				Text("By tapping \"Sign Up\" you agree to our [Terms](https://www.app-privacy-policy.com/live.php?token=FXGpbchnontnrC3F8bavORQQ7JkvBhSd) & [Policies](https://www.app-privacy-policy.com/live.php?token=rEB8U813U5IEGO8B9WvQ740GVj0PyZ6z)")
					.frame(width: 250)
					.font(.callout)
					.multilineTextAlignment(.center)
			}
			if (viewModel.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			} else {
				Button(action: {
					Task {
						if (viewModel.isSignInViewDisplayed) {
							await viewModel.signInUser()
						} else {
							await viewModel.signUpUser()
						}
					}
				}) {
					Text(viewModel.isSignInViewDisplayed ? "Sign In" : "Sign Up")
						.frame(maxWidth: .infinity, minHeight: 35)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
			}
			HStack {
				Text(viewModel.isSignInViewDisplayed ? "Don't have an account?" : "Already have an account?")
				Button(action: viewModel.toggleSignIn) {
					Text(viewModel.isSignInViewDisplayed ? "Sign Up" : "Sign In")
				}
			}
		}
		.animation(.easeInOut(duration: 0.2), value: viewModel.isKeyboardPresented)
		.onReceive(keyboardPublisher) { value in
			viewModel.isKeyboardPresented = value
		}
		.padding()
	}
}

struct AuthView_Previews: PreviewProvider {
	static var previews: some View {
		AuthView(viewModel: AuthViewModel())
	}
}
