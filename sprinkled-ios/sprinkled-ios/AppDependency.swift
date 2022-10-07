final class AppDependency {
	fileprivate init() {}
	
	lazy var api: APIType = API()
}

extension AppDependency: HasAPI {}

let dependencies = AppDependency()

