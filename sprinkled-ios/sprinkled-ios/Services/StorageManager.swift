import FirebaseStorage
import UIKit

protocol StorageManagerProtocol {
	func uploadImage(image: UIImage) async throws -> URL
}

final class StorageManager: StorageManagerProtocol {
	let storage = Storage.storage()
	
	func uploadImage(image: UIImage) async throws -> URL {
		let storageRef = storage.reference().child("images/\(UUID()).jpg")
		let data = image.jpegData(compressionQuality: 0.2)
		guard let data else {
			throw StorageManagerError.conversionError
		}
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpg"
		_ = try await storageRef.putDataAsync(data, metadata: metadata)
		return try await storageRef.downloadURL()
	}
}

final class TestStorageManager: StorageManagerProtocol {
	func uploadImage(image: UIImage) async throws -> URL {
		return URL(string: "https://www.thespruce.com/thmb/FkCnwYhQvE6wjH9THATcC6JcMiA=/941x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/grow-ficus-trees-1902757-1-80b8738caf8f42f28a24af94c3d4f314.jpg")!
	}
}
