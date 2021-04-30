// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "swift-locks",
    products: [
        .library(
            name: "Locks",
            targets: ["Locks"]),
        .library(
            name: "CSpinLock",
            targets: ["CSpinLock"]),
    ],
    targets: [
        .target(name: "CSpinLock"),
        .target(
            name: "Locks",
            dependencies: ["CSpinLock"]),
        .testTarget(
            name: "LocksTests",
            dependencies: ["Locks"]),
    ]
)
