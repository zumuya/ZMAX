// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ZMAX",
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
