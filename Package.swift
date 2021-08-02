// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ZMAX",
    platforms: [
        .macOS(.v10_14_4),    //.v10_14_4 - .v10_15
    ],
    targets: [
        .target(name: "ZMAXLib")]
)
