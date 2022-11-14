import SwiftUI

struct TabBarView: View {
	@EnvironmentObject var tabBarState: TabBarState
	@Namespace var animation
	
	var body: some View {
		HStack(spacing: 0) {
			TabBarIconView("TaskViewIcon", tag: 0)
			TabBarIconView("MyPlantsViewIcon", tag: 1)
			TabBarIconView("SearchViewIcon", tag: 2)
			TabBarIconView("ProfileViewIcon", tag: 3)
		}
		.padding(.horizontal, 10)
		.background {
			Color.sprinkledTabBarColor
				.shadow(radius: 1)
				.ignoresSafeArea()
		}
		.animation(.easeInOut(duration: 0.1), value: tabBarState.selection)
	}
	
	@ViewBuilder
	func TabBarIconView(_ name: String, tag: Int) -> some View {
		VStack(spacing: 0) {
			if (tabBarState.selection == tag) {
				Rectangle()
					.frame(width: 70, height: 2)
					.foregroundColor(.sprinkledGreen)
					.matchedGeometryEffect(id: "tab", in: animation)
			} else {
				Rectangle()
					.frame(width: 70, height: 2)
					.foregroundColor(.clear)
			}
			Image(tabBarState.selection == tag ? name + "Selected" : name)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 30, height: 30)
				.foregroundColor(tabBarState.selection == tag ? .sprinkledGreen : .primary)
				.scaleEffect(tabBarState.selection == tag ? 0.9 : 0.86)
				.padding(.top, 15)
				.background {}
				.frame(maxWidth: .infinity)
				.contentShape(Rectangle())
				.onTapGesture {
					if (tabBarState.selection == tag) {
						tabBarState.tappedSameCount += 1
					} else {
						tabBarState.tappedSameCount = 0
					}
					tabBarState.selection = tag
				}
		}
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView()
			.environmentObject(TabBarState())
	}
}
