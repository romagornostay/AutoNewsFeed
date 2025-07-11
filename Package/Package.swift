// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AutoNewsFeed",
  platforms: [.iOS(.v15)],
  products: Product.libraries(),
  //dependencies: Package.Dependency.dependencies(),
  targets: Target.targets(),
  swiftLanguageModes: [.v5]
)

extension Product {
  static func libraries() -> [Product] {
    [
      .library(
        name: .Module.app.rawValue,
        targets: [.Module.app.rawValue]
      ),
    ]
  }
}

extension Package.Dependency {
  static func dependencies() -> [Package.Dependency] {
    [
      .package(
        url: github("kean/Nuke"),
        from: "12.8.0"
      ),
      .package(
        url: github("airbnb/lottie-spm"),
        from: "4.5.0"
      ),
    ]
  }
}

extension Target {
  static func targets() -> [Target] {
    // MARK: Modules
    
    let modules: [Target] = [
      Target.module(
        name: .Module.app.rawValue,
        dependencies: .modules([.newsFeed])
      ),
      Target.module(
        name: .Module.newsFeed.rawValue,
        dependencies: .modules([.newsDetail]) + .frameworks([.appNavigation, .network, .services, .ui])
      ),
      Target.module(
        name: .Module.newsDetail.rawValue,
        dependencies: .frameworks([.appNavigation])
      ),
    ]
  
    // MARK: Frameworks
    
    let frameworks: [Target] = [
      Target.framework(
        name: .Framework.api.rawValue,
        dependencies: .frameworks([.network])
      ),
      Target.framework(
        name: .Framework.appNavigation.rawValue,
        dependencies: .frameworks([])
      ),
      Target.framework(
        name: .Framework.formatters.rawValue,
        dependencies: .frameworks([])
      ),
      Target.framework(
        name: .Framework.models.rawValue,
        dependencies: .frameworks([])
      ),
      Target.framework(
        name: .Framework.network.rawValue,
        dependencies: .frameworks([])
      ),
      Target.framework(
        name: .Framework.services.rawValue,
        dependencies: .frameworks([.api, .models])
      ),
      Target.framework(
        name: .Framework.support.rawValue,
        dependencies: .frameworks([.models])
      ),
      Target.framework(
        name: .Framework.ui.rawValue,
        dependencies: .frameworks([.formatters, .models, .support])
      ),
    ]
    
    // MARK: Binaries
    
    let binaries: [Target] = []
    
    
    // MARK: Resources
    
    let resources: [Target] = [
//      Target.resources(
//        name: .Framework.resources.rawValue,
//        resources: .resources()
//      ),
    ]
    
    // MARK: Tests
    
    let frameworksTests: [Target] = [
//      Target.testTarget(
//        name: .Target.frameworksTests.rawValue,
//        dependencies: .module(.app)
//      ),
    ]
    
    let modulesTests: [Target] = [
//      Target.testTarget(
//        name: .Target.modulesTests.rawValue,
//        dependencies: .module(.app)
//      ),
    ]
    
    return modules + frameworks + binaries + resources + frameworksTests + modulesTests
  }
}

extension String {
  enum Framework: String {
    case analytics = "Analytics"
    case api = "API"
    case appNavigation = "AppNavigation"
    case formatters = "Formatters"
    case models = "Models"
    case network = "Network"
    case resources = "Resources"
    case services = "Services"
    case support = "SupportKit"
    case ui = "UIComponents"
  }
  
  enum Module: String {
    case app = "App"
    case newsFeed = "NewsFeed"
    case newsDetail = "NewsDetail"
  }
  
  enum Product {
    case nuke
    case lottie
  }
  
  enum Resources: String, CaseIterable {
    case assets = "Assets"
    case fonts = "Fonts"
    case localization = "Localization"
    case lottie = "Lottie"
  }
  
  enum Binary: String {
    case someBinary = "SomeBinary"
  }
  
  enum Target: String {
    case frameworksTests = "FrameworksTests"
    case modulesTests = "ModulesTests"
  }
}

extension Target {
  static func module(name: String, dependencies: [Target.Dependency] = []) -> Target {
    Target.target(name: name, dependencies: dependencies, path: "Sources/Modules/\(name)")
  }
  
  static func framework(name: String, dependencies: [Target.Dependency] = []) -> Target {
    Target.target(name: name, dependencies: dependencies, path: "Sources/Frameworks/\(name)")
  }

  static func localBinary(name: String) -> Target {
    Target.binaryTarget(name: name, path: "LocalBinaries/\(name).xcframework")
  }

  static func resources(
    name: String,
    resources: [PackageDescription.Resource]? = nil,
    plugins: [PluginUsage]? = nil
  ) -> Target {
    Target.target(
      name: name,
      path: "Sources/Frameworks/\(name)",
      resources: resources,
      plugins: plugins
    )
  }
}

extension Array where Element == Resource {
  static func resources(_ array: [String.Resources] = String.Resources.allCases) -> [Resource] {
    array.map { .process($0.rawValue) }
  }
}

extension Array where Element == Target.Dependency {
  static func binaries(_ targets: [String.Binary]) -> [Target.Dependency] {
    targets.flatMap { binary($0) }
  }

  static func binary(_ target: String.Binary) -> [Target.Dependency] {
    [Target.Dependency.target(name: target.rawValue)]
  }

  static func modules(_ targets: [String.Module]) -> [Target.Dependency] {
    targets.flatMap { module($0) }
  }

  static func frameworks(_ targets: [String.Framework]) -> [Target.Dependency] {
    targets.flatMap { framework($0) }
  }

  static func products(_ products: [String.Product]) -> [Target.Dependency] {
    products.flatMap { product($0) }
  }

  static func module(_ target: String.Module) -> [Target.Dependency] {
    [Target.Dependency.target(name: target.rawValue)]
  }

  static func framework(_ target: String.Framework) -> [Target.Dependency] {
    [Target.Dependency.target(name: target.rawValue)]
  }

  static func product(_ target: String.Product) -> [Target.Dependency] {
    var result: Target.Dependency
    switch target {
    case .nuke:
      result = Target.Dependency.product(
        name: "Nuke",
        package: "Nuke"
      )
    case .lottie:
      result = Target.Dependency.product(
        name: "Lottie",
        package: "lottie-spm"
      )
    }
    return [result]
  }
}

func github(_ http: String) -> String {
  let basePath = "https://github.com/"
  return basePath + http
}
