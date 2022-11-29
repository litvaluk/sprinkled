import SwiftUI

struct ConnectionErrorPopupView: View {
	var body: some View {
		HStack(spacing: 8) {
			Image(systemName: "wifi.slash")
				.foregroundColor(.white)
				.frame(width: 24, height: 24)
			Text("No internet connection")
				.foregroundColor(.white)
				.font(.system(size: 16))
		}
		.padding(16)
		.background(Color.sprinkledRed.cornerRadius(12))
		.padding(.horizontal, 16)
	}
}

struct ConnectionErrorPopupView_Previews: PreviewProvider {
	static var previews: some View {
		ConnectionErrorPopupView()
	}
}
