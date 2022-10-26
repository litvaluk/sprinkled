import SwiftUI
import Kingfisher
import Shimmer

struct PlantEntryView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: PlantEntryViewModel
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			ScrollView {
				VStack {
					PlantEntryHeaderView(plantEntryName: vm.plantEntry?.name, pictureUrl: vm.plantEntry?.headerPictureUrl)
					PlantEntryContent(vm: vm)
						.padding(.horizontal)
				}
			}
			.toolbar(.hidden)
			.ignoresSafeArea(.all, edges: [.top])
		}
		.overlay(alignment: .topLeading) {
			Button {
				self.presentationMode.wrappedValue.dismiss()
			} label: {
				Image(systemName: "chevron.left")
					.resizable()
					.scaledToFit()
					.frame(width: 16, height: 19)
					.fontWeight(.medium)
					.padding([.top], 12)
					.padding([.leading], 7)
			}
		}
	}
}

struct PlantEntryHeaderView: View {
	let plantEntryName: String?
	let pictureUrl: String?
	
	init(plantEntryName: String?, pictureUrl: String?) {
		self.plantEntryName = plantEntryName
		self.pictureUrl = pictureUrl
	}
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GeometryReader { gr in
				if let pictureUrl {
					if (gr.frame(in: .global).minY <= 0) {
						KFImage(URL(string: pictureUrl)!)
							.resizable()
							.scaledToFill()
							.frame(width: gr.size.width, height: gr.size.height)
							.offset(y: gr.frame(in: .global).minY/9)
							.clipped()
					} else {
						KFImage(URL(string: pictureUrl)!)
							.resizable()
							.scaledToFill()
							.frame(width: gr.size.width, height: gr.size.height + gr.frame(in: .global).minY)
							.clipped()
							.offset(y: -gr.frame(in: .global).minY)
					}
				} else {
					Rectangle()
						.foregroundColor(.sprinkledGray)
						.shimmering()
						.frame(width: gr.size.width, height: gr.frame(in: .global).minY <= 0 ? gr.size.height : gr.size.height + gr.frame(in: .global).minY)
						.offset(y: gr.frame(in: .global).minY <= 0 ? 0 : -gr.frame(in: .global).minY)
				}
			}
			.frame(height: 200)
		}
		HStack {
			VStack(alignment: .leading) {
				Text(plantEntryName ?? .placeholder(10))
					.foregroundColor(.primary)
					.font(.title)
					.redactedShimmering(if: plantEntryName == nil)
				Text(plantEntryName ?? .placeholder(10))
					.foregroundColor(.primary)
					.font(.title3)
					.redactedShimmering(if: plantEntryName == nil)
			}
			Spacer()
			Button {} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.frame(width: 60, height: 60)
						.foregroundColor(.sprinkledGreen)
					Image(systemName: "plus")
						.resizable()
						.foregroundColor(.white)
						.fontWeight(.medium)
						.frame(width: 30, height: 30)
				}
			}
		}
		.padding(.horizontal)
	}
}

struct PlantEntryContent: View {
	@Namespace var namespace
	@StateObject var vm: PlantEntryViewModel
	
	var body: some View {
		HStack() {
			ForEach(PlantEntrySection.allCases, id: \.self) { section in
				ZStack {
					if (vm.selectedSection == section) {
						RoundedRectangle(cornerRadius: 7)
							.foregroundColor(.sprinkledGreen)
							.matchedGeometryEffect(id: "selection", in: namespace)
					}
					Text(section.rawValue)
						.foregroundColor(vm.selectedSection == section ? .white : .primary)
						.frame(maxWidth: .infinity)
						.frame(height: 30)
				}
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.15)) {
						vm.selectedSection = section
					}
				}
			}
		}
		.padding(6)
		.background {
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(.sprinkledGray)
		}
		switch(vm.selectedSection) {
		case .history:
			PlantEntryListItem(title: "Action", subtitle: "User", date: Date())
				.redactedShimmering(if: vm.plantEntry == nil)
		case .reminders:
			PlantEntryListItem(title: "Action", subtitle: "Every 4 days", date: Date())
				.redactedShimmering(if: vm.plantEntry == nil)
		case .gallery:
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
				ForEach(0..<13) { i in
					GalleryItem(user: "User", date: Date())
						.redactedShimmering(if: vm.plantEntry == nil)
				}
			}
		}
	}
}

struct PlantEntryListItem: View {
	let title: String
	let subtitle: String
	let date: Date
	let dayDateFormatter = DateFormatter()
	let timeDateFormatter = DateFormatter()
	
	init(title: String, subtitle: String, date: Date) {
		self.title = title
		self.subtitle = subtitle
		self.date = date
		dayDateFormatter.dateFormat = "MMM d, y"
		timeDateFormatter.dateFormat = "HH:mm"
	}
	
	var body: some View {
		VStack (spacing: 8) {
			ForEach(0..<3) { i in
				ZStack {
					Color.sprinkledGray
						.cornerRadius(10)
					HStack {
						RoundedRectangle(cornerRadius: 7)
							.foregroundColor(.gray)
							.frame(width: 50, height: 50)
							.padding(5)
						VStack(alignment: .leading) {
							Text(title)
								.fontWeight(.medium)
							Text(subtitle)
						}
						Spacer()
						VStack(alignment: .trailing) {
							Spacer()
							Text(dayDateFormatter.string(from: date))
								.font(.subheadline)
							Text(timeDateFormatter.string(from: date))
								.font(.subheadline)
							Spacer()
						}
						.padding(.trailing, 5)
					}
				}
			}
		}
	}
}

struct GalleryItem: View {
	let user: String
	let date: Date
	let dayDateFormatter = DateFormatter()
	let timeDateFormatter = DateFormatter()
	
	init(user: String, date: Date) {
		self.user = user
		self.date = date
		dayDateFormatter.dateFormat = "MMM d, y"
		timeDateFormatter.dateFormat = "HH:mm"
	}
	
	var body: some View {
		ZStack {
			Color.sprinkledGray
				.cornerRadius(10)
				.aspectRatio(1, contentMode: .fill)
				.clipped()
			VStack {
				Spacer()
				HStack {
					VStack(alignment: .leading) {
						Text(user)
							.font(.caption2)
						Text(dayDateFormatter.string(from: date))
							.font(.caption2)
						Text(timeDateFormatter.string(from: date))
							.font(.caption2)
					}
					Spacer()
				}
				
			}
			.padding(6)
		}
	}
}

struct PlantEntryView_Previews: PreviewProvider {
	static var previews: some View {
		PlantEntryView(vm: PlantEntryViewModel(plantEntryId: 1))
	}
}
