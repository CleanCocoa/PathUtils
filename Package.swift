// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "PathUtils",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "PathUtils",
            targets: ["PathUtils"]),
        .library(
            name: "PathUtils-Dynamic",
            type: .dynamic,
            targets: ["PathUtils"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "PathUtils",
            dependencies: []),
        .testTarget(
            name: "PathUtilsTests",
            dependencies: ["PathUtils"]),
    ]
)
