import SwiftUI
import Kingfisher

struct PictureView: View {
	@EnvironmentObject var pictureViewState: PictureViewState
	@GestureState var draggingOffset: CGSize = .zero
	
	var body: some View {
		if (!pictureViewState.pictures.isEmpty) {
			ZStack {
				Color.black
					.opacity(pictureViewState.bgOpacity)
					.ignoresSafeArea()
					.statusBarHidden()
				TabView(selection: $pictureViewState.selection) {
					ForEach(pictureViewState.pictures, id: \.id) { picture in
						VStack {
							KFImage(URL(string: picture.url)!)
								.resizable()
								.scaledToFit()
								.offset(pictureViewState.offset)
								.scaleEffect(pictureViewState.selection == picture.id ? (pictureViewState.scale > 1 ? pictureViewState.scale : 1) : 1)
								.tag(picture.id)
								.gesture(MagnificationGesture().onChanged({ value in
									pictureViewState.scale = value
								}).onEnded({ _ in
									withAnimation(.spring()) {
										pictureViewState.scale = 1
									}
								}))
							if (!(pictureViewState.offsetDistance() > 0 || pictureViewState.scale > 1)) {
								HStack(alignment: .top) {
									Text("\(picture.user.username)")
										.foregroundColor(.white)
										.padding(.horizontal)
										.padding(.vertical, 3)
									Spacer()
									VStack(alignment: .trailing) {
										Text(picture.createdAt.toString(.MMMdy))
											.foregroundColor(.white)
										Text(picture.createdAt.toString(.HHmm))
											.foregroundColor(.white)
									}
									.padding(.horizontal)
									.padding(.vertical, 3)
								}
							}
						}
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .always))
			}
			.gesture(DragGesture().updating($draggingOffset, body: { value, outValue, _ in
				outValue = value.translation
				let distance = sqrt(pow(value.translation.height, 2) + pow(value.translation.width, 2))
				let halfDiagonal = sqrt(pow(UIScreen.main.bounds.height, 2) + pow(UIScreen.main.bounds.width, 2))/2
				pictureViewState.bgOpacity = Double(1 - distance/halfDiagonal)
				pictureViewState.offset = draggingOffset
			}).onEnded({ value in
				withAnimation(.easeInOut) {
					let distance = sqrt(pow(value.translation.height, 2) + pow(value.translation.width, 2))
					if (distance > 150) {
						pictureViewState.reset()
					}
					pictureViewState.offset = .zero
					pictureViewState.bgOpacity = 1
				}
			}))
			.overlay(alignment: .topLeading) {
				if (!(pictureViewState.offsetDistance() > 0 || pictureViewState.scale > 1)) {
					HStack {
						Button {
							pictureViewState.reset()
						} label: {
							Image(systemName: "xmark")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundColor(.white)
								.fontWeight(.medium)
								
						}
						Spacer()
						Button {
							withAnimation(.easeOut(duration: 0.07)) {
								pictureViewState.showDeleteModal = true
							}
						} label: {
							Image(systemName: "xmark.bin.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 25, height: 25)
								.foregroundColor(.white)
								.fontWeight(.medium)
								
						}
					}
					.padding([.top], 20)
					.padding([.horizontal], 20)
				}
			}
			.modal(title: "Are you sure?", showModal: $pictureViewState.showDeleteModal) {
				Text("This action will delete the chosen photo.")
					.font(.title3)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
			} buttons: {
				Button {
					Task {
						await pictureViewState.deleteCurrent()
						withAnimation(.easeOut(duration: 0.07)) {
							pictureViewState.showDeleteModal = false
						}
					}
				} label: {
					Text("Delete")
						.frame(maxWidth: .infinity, minHeight: 28)
				}
				.tint(.sprinkledRed)
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
				Button {
					withAnimation(.easeOut(duration: 0.07)) {
						pictureViewState.showDeleteModal = false
					}
				} label: {
					Text("Cancel")
						.frame(maxWidth: .infinity, minHeight: 28)
				}
				.buttonStyle(.borderedProminent)
				.cornerRadius(10)
			}
		}
	}
}

struct PictureView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			PlantEntryView(vm: PlantEntryViewModel(plantEntryId: 1))
			PictureView()
				.zIndex(1)
		}
		.environmentObject(PictureViewState())
	}
}
