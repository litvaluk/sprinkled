import SwiftUI

class PictureViewState: ObservableObject {
	@Inject private var api: APIProtocol
	
	@Published var selection: Int = 0
	@Published var pictures: [Picture] = []
	@Published var offset: CGSize = .zero
	@Published var bgOpacity: Double = 1
	@Published var scale: CGFloat = 1
	@Published var showDeleteModal = false
	
	var onDelete: () -> Void = {}
	
	private let errorPopupsState: ErrorPopupsState
	
	init(errorPopupsState: ErrorPopupsState) {
		self.errorPopupsState = errorPopupsState
	}
	
	func reset() {
		withAnimation(.easeInOut(duration: 0.2)) {
			pictures = []
		}
	}
	
	func set(selection: Int, pictures: [Picture], onDelete: @escaping () -> Void = {}) {
		withAnimation(.easeInOut(duration: 0.2)) {
			self.selection = selection
			self.pictures = pictures
		}
		self.onDelete = onDelete
	}
	
	func offsetDistance() -> Double {
		return sqrt(pow(offset.height, 2) + pow(offset.width, 2))
	}
	
	func deleteCurrent() async {
		do {
			try await api.deletePicture(pictureId: selection)
			onDelete()
			let index = pictures.firstIndex(where: {$0.id == selection})!
			if (pictures.count == 1) {
				reset()
			} else if (index == 0) {
				selection = pictures[index + 1].id
				pictures.remove(at: index)
			} else {
				selection = pictures[index - 1].id
				pictures.remove(at: index)
			}
		} catch APIError.expiredRefreshToken {
			// nothing
		}
		catch APIError.notConnectedToInternet {
			errorPopupsState.showConnectionError = true
		} catch {
			errorPopupsState.showGenericError = true
		}
	}
}
