import SwiftUI

struct GenericErrorPopupView: View {
	var body: some View {
		HStack(spacing: 8) {
			Image(systemName: "exclamationmark.triangle.fill")
				.foregroundColor(.white)
				.frame(width: 24, height: 24)
			Text("Something went wrong")
				.foregroundColor(.white)
				.font(.system(size: 16))
		}
		.padding(16)
		.background(Color.sprinkledRed.cornerRadius(12))
		.padding(.horizontal, 16)
	}
}

struct GenericErrorPopupView_Previews: PreviewProvider {
	static var previews: some View {
		GenericErrorPopupView()
	}
}
