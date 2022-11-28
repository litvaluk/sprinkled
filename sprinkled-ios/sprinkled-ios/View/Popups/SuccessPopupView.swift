import SwiftUI

struct SuccessPopupView: View {
	let text: String
	
	var body: some View {
		HStack(spacing: 8) {
			Image(systemName: "checkmark")
				.foregroundColor(.white)
				.frame(width: 24, height: 24)
			Text(text)
				.foregroundColor(.white)
				.font(.system(size: 16))
		}
		.padding(16)
		.background(Color.sprinkledGreen.cornerRadius(12))
		.padding(.horizontal, 16)
	}
}

struct SuccessPopupView_Previews: PreviewProvider {
    static var previews: some View {
		SuccessPopupView(text: "Success!")
    }
}
