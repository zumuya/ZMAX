// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ZMAX",
    platforms: [
        .macOS(.v10_15)
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
