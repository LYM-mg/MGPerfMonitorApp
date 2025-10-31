// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MGPerfMonitor",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MGPerfMonitor",
            targets: ["MGPerfMonitor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devicekit/DeviceKit.git", .upToNextMajor(from: "5.7.0")),
//        .package(url: "https://github.com/JasonCai-ai/BigoADS", from: "5.0.0"),
//        .package(url: "https://github.com/mac-cain13/R.swift", from: "7.8.0"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MGPerfMonitor",
            dependencies: [
                "DeviceKit",
            ],
            resources: [
                .process("Resources")
            ]
//            dependencies: [
//                .product(name: "BigoADS", package: "BigoADS"),
//                .product(name: "R", package: "R"),
//            ],
        ),
        .testTarget(
            name: "MGPerfMonitorTests",
            dependencies: ["MGPerfMonitor"]
        ),
    ]
)
