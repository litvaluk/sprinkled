import SwiftUI

struct OnboardingStep {
	let title: String
	let image: String
	let description: String
}

struct OnboardingView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@StateObject var vm: OnboardingViewModel
	
	private let steps = [
		OnboardingStep(title: "Title 1", image: "GridPlaceholderImage", description: "Description 1"),
		OnboardingStep(title: "Title 2", image: "GridPlaceholderImage", description: "Description 2"),
		OnboardingStep(title: "Title 3", image: "GridPlaceholderImage", description: "Description 3"),
		OnboardingStep(title: "Title 4", image: "GridPlaceholderImage", description: "Description 4")
	]
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Text("Skip")
						.foregroundColor(.sprinkledGreen)
						.font(.title3)
				}
				.disabled(vm.currentStep == steps.count - 1)
				.opacity(vm.currentStep == steps.count - 1 ? 0 : 1)
			}
			Spacer()
			TabView(selection: $vm.currentStep) {
				ForEach(Array(steps.enumerated()), id: \.offset) { i, step in
					VStack {
						Text(step.title)
							.font(.title)
							.bold()
							.padding(.horizontal, 32)
							.padding(.bottom, 2)
						Text(step.description)
							.multilineTextAlignment(.center)
							.padding(.horizontal, 32)
							.padding(.bottom, 15)
						Image(step.image)
							.resizable()
							.scaledToFill()
					}
					.tag(i)
				}
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.animation(.easeInOut(duration: 0.1), value: vm.currentStep)
			Spacer()
			HStack {
				ForEach(steps.indices, id: \.self) { i in
					Circle()
						.frame(width: 8, height: 8)
						.foregroundColor(i == vm.currentStep ? .sprinkledGreen : .sprinkledDarkerGray)
						.animation(.easeInOut(duration: 0.1), value: vm.currentStep)
				}
			}
			.padding(15)
			SprinkledButton(text: vm.currentStep == steps.count - 1 ? "Get Started" : "Next") {
				if (vm.currentStep < steps.count - 1) {
					vm.currentStep += 1
				} else {
					presentationMode.wrappedValue.dismiss()
				}
			}
		}
		.padding()
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(vm: OnboardingViewModel())
	}
}
