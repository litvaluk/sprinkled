import SwiftUI
import Kingfisher

struct PictureView: View {
	@EnvironmentObject var pictureViewState: PictureViewState
	
	var body: some View {
		if (!pictureViewState.pictures.isEmpty) {
			ZStack {
				Color.black
					.ignoresSafeArea(.all)
				TabView(selection: $pictureViewState.selection) {
					ForEach(pictureViewState.pictures, id: \.id) { image in
						KFImage(URL(string: image.url)!)
							.resizable()
							.scaledToFit()
							.tag(image.id)
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .always))
			}
			.overlay(alignment: .topLeading) {
				Button {
					pictureViewState.reset()
				} label: {
					Image(systemName: "xmark")
						.resizable()
						.scaledToFit()
						.frame(width: 16, height: 19)
						.foregroundColor(.white)
						.fontWeight(.medium)
						.padding([.top], 20)
						.padding([.leading], 20)
				}
			}
		}
	}
}

struct PictureView_Previews: PreviewProvider {
	static var previews: some View {
		PictureView()
			.environmentObject(PictureViewState())
	}
}
