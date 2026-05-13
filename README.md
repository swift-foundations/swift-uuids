# swift-uuids

UUIDs for Swift — RFC 4122 and RFC 9562 spec encoding bound to the platform
CSPRNG.

`swift-uuids` is the L3 unifier that composes `swift-rfc-4122` × `swift-rfc-9562`
× `swift-random`. Importing the `UUIDs` module brings the canonical typed UUID
and spec-correct v3 / v4 / v5 / v7 / v8 generators on every supported platform,
with the platform CSPRNG automatically bound:

- Darwin: `arc4random_buf`
- Linux: `getrandom(2)`
- Windows: `BCryptGenRandom`

## Quick Start

```swift
import UUIDs

// Version 4 (random) — 122 bits from the platform CSPRNG.
let id = try RFC_4122.UUID.v4()

// Version 7 (Unix-ms timestamp + random) — time-ordered, recommended for new
// applications per RFC 9562 §5.7.
let now: Int64 = 1_645_557_742_000
let key = try RFC_9562.UUID.v7(unixMilliseconds: now)
```

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-uuids.git", from: "0.1.0")
],
targets: [
    .target(
        name: "MyTarget",
        dependencies: [
            .product(name: "UUIDs", package: "swift-uuids")
        ]
    )
]
```

## License

Apache License 2.0. See [LICENSE.md](LICENSE.md).
