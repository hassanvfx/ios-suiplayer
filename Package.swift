// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AVPlayerSwiftUI",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AVPlayerSwiftUI",
            targets: ["AVPlayerSwiftUI"]),
    ],
    dependencies: [
        .package(name: "Lux", url: "https://github.com/spree3d/lux-1", .exact("1.2.7")),
    ],
    targets: [
        .target(
            name: "AVPlayerSwiftUI",
            dependencies: ["Lux"]),
        .testTarget(
            name: "FrameworkTests",
            dependencies: ["AVPlayerSwiftUI"]),
    ]
)
