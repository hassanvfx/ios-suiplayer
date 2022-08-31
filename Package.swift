// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUIPlayer",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SUIPlayer",
            targets: ["SUIPlayer"]),
    ],
    dependencies: [
        .package(name: "Lux", url: "https://github.com/spree3d/lux-1", .exact("1.2.7")),
    ],
    targets: [
        .target(
            name: "SUIPlayer",
            dependencies: ["Lux"]),
        .testTarget(
            name: "FrameworkTests",
            dependencies: ["SUIPlayer"]),
    ]
)
