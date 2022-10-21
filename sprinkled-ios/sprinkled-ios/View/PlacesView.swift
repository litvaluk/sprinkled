import SwiftUI

struct PlaceView: View {
	let place: TeamSummaryPlace
	
    var body: some View {
        Text("PlaceView")
			.navigationTitle(place.name)
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
		PlaceView(place: TestData.teamSummaries[0].places[0])
    }
}
