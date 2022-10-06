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
				TextField("Email", text: $viewModel.signInEmail)
					.padding()
					.background(.thinMaterial)
					.cornerRadius(10)
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					.keyboardType(.emailAddress)
				SecureField("Password", text: $viewModel.signInPassword)
					.padding()
					.background(.thinMaterial)
					.cornerRadius(10)
			} else {
				TextField("Email", text: $viewModel.signUpEmail)
					.padding()
					.background(.thinMaterial)
					.cornerRadius(10)
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					.keyboardType(.emailAddress)
				SecureField("Password", text: $viewModel.signUpPassword)
					.padding()
					.background(.thinMaterial)
					.cornerRadius(10)
				SecureField("Confirm password", text: $viewModel.signUpPasswordConfirmation)
					.padding()
					.background(.thinMaterial)
					.cornerRadius(10)
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
			Button(action: viewModel.isSignInViewDisplayed ? viewModel.signInUser : viewModel.signUpUser) {
				Text(viewModel.isSignInViewDisplayed ? "Sign In" : "Sign Up")
					.foregroundColor(.white)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.sprinkledGreen)
			.cornerRadius(10)
//			.disabled(viewModel.isProcessing || viewModel.isSignInViewDisplayed ? viewModel.signInEmail.isEmpty || viewModel.signInPassword.isEmpty : viewModel.signUpEmail.isEmpty || viewModel.signUpPassword.isEmpty || viewModel.signUpPasswordConfirmation.isEmpty)
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
		AuthView(viewModel: AuthViewModel())
	}
}
