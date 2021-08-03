// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ZMAX",
    platforms: [
        .macOS(.v10_14.4)
    ],
    products: [
        .library(
            name: "ZMAX",
            targets: ["ZMAX"]),
    ],
    targets: [
        .target(
            name: "ZMAX",
            path: "ZMAX/Sources"),
    ]
)
