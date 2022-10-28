import SwiftUI

class PictureViewState: ObservableObject {
	@Published var selection: Int = 0
	@Published var pictures: [Picture] = []
	
	func reset() {
		let window = UIApplication.shared.connectedScenes
				.filter({$0.activationState == .foregroundActive})
				.compactMap({$0 as? UIWindowScene})
				.first?.windows
				.filter({$0.isKeyWindow}).first
		if let window {
			UIView.transition (with: window, duration: 0.2, options: .curveEaseInOut, animations: {
				window.overrideUserInterfaceStyle = .unspecified
			}, completion: nil)
		}
		withAnimation(.easeInOut(duration: 0.2)) {
			pictures = []
			
		}
	}
	
	func set(selection: Int, pictures: [Picture]) {
		let window = UIApplication.shared.connectedScenes
				.filter({$0.activationState == .foregroundActive})
				.compactMap({$0 as? UIWindowScene})
				.first?.windows
				.filter({$0.isKeyWindow}).first
		if let window {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				window.overrideUserInterfaceStyle = .dark
			}
		}
		withAnimation(.easeInOut(duration: 0.2)) {
			self.selection = selection
			self.pictures = pictures
		}
	}
}
