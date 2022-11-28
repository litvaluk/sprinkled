import SwiftUI
import Kingfisher

struct PlantDetailView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@EnvironmentObject var errorPopupsState: ErrorPopupsState
	@StateObject var vm: PlantDetailViewModel
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			ScrollView {
				VStack {
					PlantHeaderView(commonName: vm.plant.commonName, latinName: vm.plant.latinName, pictureUrl: vm.plant.pictureUrl) {
						vm.addPlantEntryPresented = true
					}
					HStack {
						InfoBoxView(icon: Image("Difficulty"), title: "Difficulty", value: "Easy")
						InfoBoxView(icon: Image("Water"), title: "Water", value: "Moderate")
					}
					.padding([.top], 2)
					.padding([.leading, .trailing], 10)
					HStack {
						if (vm.unitSystem == "Imperial") {
							InfoBoxView(icon: Image("Temperature"), title: "Temperature", value: String(Utils.calculateFahrenheit(Double(vm.plant.minTemp)).rounded().toInt()!) + " °F - " + String(Utils.calculateFahrenheit(Double(vm.plant.maxTemp)).rounded().toInt()!) + " °F")
						} else {
							InfoBoxView(icon: Image("Temperature"), title: "Temperature", value: String(vm.plant.minTemp) + " °C - " + String(vm.plant.maxTemp) + " °C")
						}
						InfoBoxView(icon: Image("Fullsun"), title: "Light", value: vm.plant.light)
					}
					.padding([.leading, .trailing], 10)
					HStack {
						if (vm.unitSystem == "Imperial") {
							InfoBoxView(icon: Image("Height"), title: "Height", value: Utils.calculateFeetAndInches(vm.plant.minHeight).toString() + " - " + Utils.calculateFeetAndInches(vm.plant.maxHeight).toString())
							InfoBoxView(icon: Image("Spread"), title: "Spread", value: Utils.calculateFeetAndInches(vm.plant.minSpread).toString() + " - " + Utils.calculateFeetAndInches(vm.plant.maxSpread).toString())
						} else {
							InfoBoxView(icon: Image("Height"), title: "Height", value: vm.plant.minHeight.toString() + " - " + vm.plant.maxHeight.toString() + " m")
							InfoBoxView(icon: Image("Spread"), title: "Spread", value: vm.plant.minSpread.toString() + " - " + vm.plant.maxSpread.toString() + " m")
						}
					}
					.padding([.leading, .trailing], 10)
					DescriptionBoxView(text: vm.plant.description)
				}
			}
			.toolbar(.hidden)
			.ignoresSafeArea(.all, edges: [.top])
		}
		.fullScreenCover(isPresented: $vm.addPlantEntryPresented) {
			AddPlantEntryView(vm: AddPlantEntryViewModel(plant: vm.plant, errorPopupsState: errorPopupsState, setupPlanPresented: $vm.setupPlanPresented, lastCreatedPlantEntry: $vm.lastCreatedPlantEntry))
				.ignoresSafeArea(.keyboard, edges: .bottom)
		}
		.fullScreenCover(isPresented: $vm.setupPlanPresented) {
			SetPlanView(vm: SetPlanViewModel(plantEntryId: vm.lastCreatedPlantEntry!.id, plantEntryName: vm.lastCreatedPlantEntry!.name, plans: vm.plant.plans, errorPopupsState: errorPopupsState))
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

struct PlantHeaderView: View {
	let commonName: String
	let latinName: String
	let pictureUrl: String
	let addPlantEntryButtonAction: () -> Void
	
	init(commonName: String, latinName: String, pictureUrl: String, addPlantEntryButtonAction: @escaping () -> Void) {
		self.commonName = commonName
		self.latinName = latinName
		self.pictureUrl = pictureUrl
		self.addPlantEntryButtonAction = addPlantEntryButtonAction
	}
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			GeometryReader { gr in
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
			}
			.frame(height: 200)
		}
		HStack {
			VStack(alignment: .leading) {
				Text(commonName)
					.foregroundColor(.primary)
					.font(.title)
				Text(latinName)
					.foregroundColor(.primary)
					.font(.title3)
			}
			Spacer()
			Button {
				addPlantEntryButtonAction()
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 15)
						.frame(width: 90, height: 60)
						.foregroundColor(.sprinkledGreen)
					Text("Add to my plants")
						.font(.subheadline)
						.foregroundColor(.white)
						.multilineTextAlignment(.center)
						.frame(width: 90, height: 60)
				}
			}
		}
		.padding([.leading, .trailing], 20)
	}
}

struct DescriptionBoxView: View {
	let text: String
	
	init(text: String) {
		self.text = text
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 15)
				.foregroundColor(.sprinkledGray)
				.padding([.leading, .trailing], 10)
			VStack (alignment: .leading, spacing: 0) {
				Text("Description")
					.font(.subheadline)
					.fontWeight(.semibold)
					.padding([.leading, .trailing], 20)
					.padding([.top], 10)
				Text(text)
					.font(.subheadline)
					.padding([.leading, .trailing], 20)
					.padding([.top, .bottom], 10)
			}
			
		}
	}
}

struct InfoBoxView: View {
	let icon: Image
	let title: String
	let value: String
	
	init(icon: Image, title: String, value: String) {
		self.icon = icon
		self.title = title
		self.value = value
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 15)
				.foregroundColor(.sprinkledGray)
			HStack {
				icon
					.resizable()
					.scaledToFit()
					.frame(width: 25, height: 25)
				VStack {
					Text(title)
						.font(.subheadline)
						.fontWeight(.semibold)
					Text(value)
						.font(.subheadline)
				}
				.frame(minWidth: 0, maxWidth: .infinity)
			}
			.padding()
		}
	}
}

struct PlantDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PlantDetailView(vm: PlantDetailViewModel(plant: TestData.plants[0]))
	}
}
