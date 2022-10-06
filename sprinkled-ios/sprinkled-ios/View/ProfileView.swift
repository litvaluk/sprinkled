import Foundation
import SwiftUI

struct ProfileView: View {
	@StateObject var viewModel: ProfileViewModel
	
    var body: some View {
		VStack {
			Text("ProfileView")
			Button(action: viewModel.logout) {
				Text("Logout")
					.foregroundColor(.white)
			}
			.padding()
			.background(Color.sprinkledGreen)
			.cornerRadius(10)
		}
		.padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
