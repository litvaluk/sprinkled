import SwiftUI

struct AuthView: View {
	@StateObject var viewModel: AuthViewModel
	
	var body: some View {
		VStack (spacing: 15) {
			Text("Sprinkled")
				.font(.system(size: 48))
				.fontWeight(.medium)
				.padding()
			if (viewModel.isSignInViewDisplayed) {
				TextField("Username", text: $viewModel.signInUsername)
					.textFieldStyle(AuthTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
				SecureField("Password", text: $viewModel.signInPassword)
					.textFieldStyle(AuthTextFieldStyle())
			} else {
				TextField("Username", text: $viewModel.signUpUsername)
					.textFieldStyle(AuthTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
				TextField("Email", text: $viewModel.signUpEmail)
					.textFieldStyle(AuthTextFieldStyle())
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					.keyboardType(.emailAddress)
				SecureField("Password", text: $viewModel.signUpPassword)
					.textFieldStyle(AuthTextFieldStyle())
				SecureField("Confirm password", text: $viewModel.signUpPasswordConfirmation)
					.textFieldStyle(AuthTextFieldStyle())
			}
			
			if !viewModel.errorMessage.isEmpty {
				Text("\(viewModel.errorMessage)")
					.foregroundColor(.red)
			}
			if (viewModel.isProcessing) {
				ProgressView()
					.scaleEffect(1.5)
					.padding()
			}
			Spacer()
			if (!viewModel.isSignInViewDisplayed) {
				Text("By tapping \"Sign Up\" you agree to our [Terms](https://lukaslitvan.cz) & [Policies](https://lukaslitvan.cz)")
					.frame(width: 250)
					.font(.callout)
					.multilineTextAlignment(.center)
			}
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
					.foregroundColor(.white)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.sprinkledGreen)
			.cornerRadius(10)
			.disabled(viewModel.isProcessing || viewModel.isSignInViewDisplayed ? viewModel.signInUsername.isEmpty || viewModel.signInPassword.isEmpty : viewModel.signUpUsername.isEmpty || viewModel.signUpEmail.isEmpty || viewModel.signUpPassword.isEmpty || viewModel.signUpPasswordConfirmation.isEmpty)
			HStack {
				Text(viewModel.isSignInViewDisplayed ? "Don't have an account?" : "Already have an account?")
				Button(action: viewModel.toggleSignIn) {
					Text(viewModel.isSignInViewDisplayed ? "Sign Up" : "Sign In")
				}
			}
		}
		.padding()
	}
}

struct AuthView_Previews: PreviewProvider {
	static var previews: some View {
		AuthView(viewModel: AuthViewModel(dependencies: dependencies))
	}
}

struct AuthTextFieldStyle: TextFieldStyle {
	@FocusState private var textFieldFocused: Bool
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.padding()
			.background(.thinMaterial)
			.cornerRadius(10)
			.focused($textFieldFocused)
			.onTapGesture {
				textFieldFocused = true
			}
	}
}
