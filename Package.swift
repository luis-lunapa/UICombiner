// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UICombiner",
    platforms: [
        .iOS(.v14), .tvOS(.v14), .watchOS(.v7),
    ],
    products: [
        .library(
            name: "UICombiner",
            targets: ["UICombiner"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "UICombiner",
            dependencies: []),
        .testTarget(
            name: "UICombinerTests",
            dependencies: ["UICombiner"]),
    ]
)
