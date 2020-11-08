// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SignalVSNoiseKit",
  platforms: [ .iOS(.v14), .macOS(.v10_15) ],
  products: [
    .library(
      name: "SignalVSNoiseKit",
      targets: ["SignalVSNoiseKit"]
    ),
  ],
  dependencies: [
//    .package(path: "../ComposableArchitecture/"),
    .package(url: "https://github.com/insidegui/MultipeerKit.git", from: "0.3.1"),
    .package(url: "https://github.com/kstenerud/KSCrash.git", .branch("master")),
//    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.9.0"),
    .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
//    .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
    .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.4.0"),
//    .package(url: "https://github.com/steipete/InterposeKit.git", from: "0.0.2"),
  ],
  targets: [
    .target(
      name: "SignalVSNoiseKit",
      dependencies: [
//        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "KSCrash",
        "MultipeerKit",
        "Version",
        "AnyCodable",
//        "Files",
//        "InterposeKit"
      ]
    ),
    .testTarget(
      name: "SignalVSNoiseKitTests",
      dependencies: ["SignalVSNoiseKit"]
    ),
  ]
)
