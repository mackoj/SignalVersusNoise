// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SignalVSNoiseKit",
  platforms: [.iOS(.v14), .macOS(.v10_15)],
  products: [
    .library(
      name: "ClientTCADebugger",
      targets: ["ClientTCADebugger"]
    ),
    .library(
      name: "ServerTransceiver",
      targets: ["ServerTransceiver"]
    ),
    .library(
      name: "ServerTransceiverLive",
      targets: ["ServerTransceiverLive"]
    ),
    .library(
      name: "SharedCode",
      targets: ["SharedCode"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/insidegui/MultipeerKit.git", from: "0.3.1"),
    .package(url: "https://github.com/kstenerud/KSCrash.git", .branch("master")),
    .package(url: "https://github.com/mxcl/Version.git", from: "2.0.0"),
    .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.4.0"),
  ],
  targets: [
    .target(
      name: "ClientTCADebugger",
      dependencies: [
        "KSCrash",
        "MultipeerKit",
        "AnyCodable",
        "SharedCode",
      ]
    ),
    .target(
      name: "ServerTransceiverLive",
      dependencies: [
        "MultipeerKit",
        "ServerTransceiver",
      ]
    ),
    .target(
      name: "ServerTransceiver",
      dependencies: [
        "SharedCode",
        "AnyCodable",
        "MultipeerKit",
      ]
    ),
    .target(
      name: "SharedCode",
      dependencies: [
        "MultipeerKit",
        "Version",
        "AnyCodable",
      ]
    ),
  ]
)
