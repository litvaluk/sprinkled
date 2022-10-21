import XCTest
@testable import sprinkled_ios

final class SearchViewModelTests: XCTestCase {
	
	private var viewModel: SearchViewModel!
	
	override func setUp() {
		super.setUp()
		viewModel = SearchViewModel()
	}
	
	override func tearDown() {
		super.tearDown()
		viewModel = nil
	}
	
	func testPlantSearchEmptyString() async throws {
		// given
		viewModel.searchText = ""
		viewModel.plants = [
			Plant(id: 1, latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", difficulty: "diff1", water: "water1", minHeight: 1.0, maxHeight: 2.0, minSpread: 1.0, maxSpread: 2.0, minTemp: 10, maxTemp: 20, light: "light1"),
			Plant(id: 2, latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", difficulty: "diff2", water: "water2", minHeight: 2.0, maxHeight: 3.0, minSpread: 2.0, maxSpread: 3.0, minTemp: 11, maxTemp: 21, light: "light2"),
			Plant(id: 3, latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", difficulty: "diff3", water: "water3", minHeight: 3.0, maxHeight: 4.0, minSpread: 3.0, maxSpread: 4.0, minTemp: 12, maxTemp: 22, light: "light3"),
			Plant(id: 4, latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", difficulty: "diff4", water: "water4", minHeight: 4.0, maxHeight: 5.0, minSpread: 4.0, maxSpread: 5.0, minTemp: 13, maxTemp: 23, light: "light5"),
			Plant(id: 5, latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", difficulty: "diff5", water: "water5", minHeight: 5.0, maxHeight: 6.0, minSpread: 5.0, maxSpread: 6.0, minTemp: 14, maxTemp: 24, light: "light5")
		]
		
		// when
		await viewModel.updateFilteredPlants();
		
		// then
		XCTAssertTrue(viewModel.filteredPlants.count == 5)
	}
	
	func testPlantSearchNoMatch() async throws {
		// given
		viewModel.searchText = "nomatch"
		viewModel.plants = [
			Plant(id: 1, latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", difficulty: "diff1", water: "water1", minHeight: 1.0, maxHeight: 2.0, minSpread: 1.0, maxSpread: 2.0, minTemp: 10, maxTemp: 20, light: "light1"),
			Plant(id: 2, latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", difficulty: "diff2", water: "water2", minHeight: 2.0, maxHeight: 3.0, minSpread: 2.0, maxSpread: 3.0, minTemp: 11, maxTemp: 21, light: "light2"),
			Plant(id: 3, latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", difficulty: "diff3", water: "water3", minHeight: 3.0, maxHeight: 4.0, minSpread: 3.0, maxSpread: 4.0, minTemp: 12, maxTemp: 22, light: "light3"),
			Plant(id: 4, latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", difficulty: "diff4", water: "water4", minHeight: 4.0, maxHeight: 5.0, minSpread: 4.0, maxSpread: 5.0, minTemp: 13, maxTemp: 23, light: "light5"),
			Plant(id: 5, latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", difficulty: "diff5", water: "water5", minHeight: 5.0, maxHeight: 6.0, minSpread: 5.0, maxSpread: 6.0, minTemp: 14, maxTemp: 24, light: "light5")
		]
		
		// when
		await viewModel.updateFilteredPlants();
		
		// then
		XCTAssertTrue(viewModel.filteredPlants.isEmpty)
	}
	
	func testPlantSearchMatchOneLatin() async throws {
		// given
		viewModel.searchText = "in1"
		viewModel.plants = [
			Plant(id: 1, latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", difficulty: "diff1", water: "water1", minHeight: 1.0, maxHeight: 2.0, minSpread: 1.0, maxSpread: 2.0, minTemp: 10, maxTemp: 20, light: "light1"),
			Plant(id: 2, latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", difficulty: "diff2", water: "water2", minHeight: 2.0, maxHeight: 3.0, minSpread: 2.0, maxSpread: 3.0, minTemp: 11, maxTemp: 21, light: "light2"),
			Plant(id: 3, latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", difficulty: "diff3", water: "water3", minHeight: 3.0, maxHeight: 4.0, minSpread: 3.0, maxSpread: 4.0, minTemp: 12, maxTemp: 22, light: "light3"),
			Plant(id: 4, latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", difficulty: "diff4", water: "water4", minHeight: 4.0, maxHeight: 5.0, minSpread: 4.0, maxSpread: 5.0, minTemp: 13, maxTemp: 23, light: "light5"),
			Plant(id: 5, latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", difficulty: "diff5", water: "water5", minHeight: 5.0, maxHeight: 6.0, minSpread: 5.0, maxSpread: 6.0, minTemp: 14, maxTemp: 24, light: "light5")
		]
		
		// when
		await viewModel.updateFilteredPlants();
		
		// then
		XCTAssertTrue(viewModel.filteredPlants.count == 1)
		XCTAssertTrue(viewModel.filteredPlants[0].id == 1)
	}
	
	func testPlantSearchMatchOneCommon() async throws {
		// given
		viewModel.searchText = "on3"
		viewModel.plants = [
			Plant(id: 1, latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", difficulty: "diff1", water: "water1", minHeight: 1.0, maxHeight: 2.0, minSpread: 1.0, maxSpread: 2.0, minTemp: 10, maxTemp: 20, light: "light1"),
			Plant(id: 2, latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", difficulty: "diff2", water: "water2", minHeight: 2.0, maxHeight: 3.0, minSpread: 2.0, maxSpread: 3.0, minTemp: 11, maxTemp: 21, light: "light2"),
			Plant(id: 3, latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", difficulty: "diff3", water: "water3", minHeight: 3.0, maxHeight: 4.0, minSpread: 3.0, maxSpread: 4.0, minTemp: 12, maxTemp: 22, light: "light3"),
			Plant(id: 4, latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", difficulty: "diff4", water: "water4", minHeight: 4.0, maxHeight: 5.0, minSpread: 4.0, maxSpread: 5.0, minTemp: 13, maxTemp: 23, light: "light5"),
			Plant(id: 5, latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", difficulty: "diff5", water: "water5", minHeight: 5.0, maxHeight: 6.0, minSpread: 5.0, maxSpread: 6.0, minTemp: 14, maxTemp: 24, light: "light5")
		]
		
		// when
		await viewModel.updateFilteredPlants();
		
		// then
		XCTAssertTrue(viewModel.filteredPlants.count == 1)
		XCTAssertTrue(viewModel.filteredPlants[0].id == 3)
	}
	
	func testPlantSearchMatchAll() async throws {
		// given
		viewModel.searchText = "lat"
		viewModel.plants = [
			Plant(id: 1, latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", difficulty: "diff1", water: "water1", minHeight: 1.0, maxHeight: 2.0, minSpread: 1.0, maxSpread: 2.0, minTemp: 10, maxTemp: 20, light: "light1"),
			Plant(id: 2, latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", difficulty: "diff2", water: "water2", minHeight: 2.0, maxHeight: 3.0, minSpread: 2.0, maxSpread: 3.0, minTemp: 11, maxTemp: 21, light: "light2"),
			Plant(id: 3, latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", difficulty: "diff3", water: "water3", minHeight: 3.0, maxHeight: 4.0, minSpread: 3.0, maxSpread: 4.0, minTemp: 12, maxTemp: 22, light: "light3"),
			Plant(id: 4, latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", difficulty: "diff4", water: "water4", minHeight: 4.0, maxHeight: 5.0, minSpread: 4.0, maxSpread: 5.0, minTemp: 13, maxTemp: 23, light: "light5"),
			Plant(id: 5, latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", difficulty: "diff5", water: "water5", minHeight: 5.0, maxHeight: 6.0, minSpread: 5.0, maxSpread: 6.0, minTemp: 14, maxTemp: 24, light: "light5")
		]
		
		// when
		await viewModel.updateFilteredPlants();
		
		// then
		XCTAssertTrue(viewModel.filteredPlants.count == 5)
	}
}
