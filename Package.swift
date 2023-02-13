// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-locks",
    products: [
        .library(
            name: "Locks",
            targets: ["Locks"]),
    ],
    targets: [
        .target(
            name: "Locks",
            dependencies: []),
        .testTarget(
            name: "LocksTests",
            dependencies: ["Locks"]),
    ]
)
