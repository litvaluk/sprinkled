import SwiftUI

class PictureViewState: ObservableObject {
	@Published var selection: Int = 0
	@Published var pictures: [Picture] = []
	@Published var offset: CGSize = .zero
	@Published var bgOpacity: Double = 1
	@Published var scale: CGFloat = 1
	
	func reset() {
		withAnimation(.easeInOut(duration: 0.2)) {
			pictures = []
		}
	}
	
	func set(selection: Int, pictures: [Picture]) {
		withAnimation(.easeInOut(duration: 0.2)) {
			self.selection = selection
			self.pictures = pictures
		}
	}
	
	func offsetDistance() -> Double {
		return sqrt(pow(offset.height, 2) + pow(offset.width, 2))
	}
}
