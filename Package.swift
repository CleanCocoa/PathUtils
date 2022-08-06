// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "PathUtils",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .library(
            name: "PathUtils",
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
