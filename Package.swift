// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let platforms: [SupportedPlatform] = [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)]
let products: [Product] = [.library(name: "BLZipper", targets: ["BLZipper"])]
let testResources: [Resource] = [
    .copy("Resources/audiosample.mp3")
]
let targets: [Target] = [
    .target(name: "BLZipper"),
    .testTarget(name: "BLZipperTests", dependencies: ["BLZipper"], resources: testResources)
]

let package = Package(
    name: "BLZipper",
    platforms: platforms,
    products: products,
    targets: targets
)
