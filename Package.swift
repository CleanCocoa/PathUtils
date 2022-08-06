// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Filename",
    products: [
        .library(
            name: "Filename",
            targets: ["Filename"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Filename",
            dependencies: []),
        .testTarget(
            name: "FilenameTests",
            dependencies: ["Filename"]),
    ]
)
