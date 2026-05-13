// Exports.swift
// Re-exports for swift-uuids L3 unifier module.
//
// swift-uuids composes the RFC 4122 / RFC 9562 spec encoding (L2) with the
// platform CSPRNG (L3 swift-random) per [PLAT-ARCH-009]. Consumers writing
// `import UUIDs` get the canonical typed UUID + spec-correct v3/v4/v5/v7/v8
// generators on every platform.

@_exported public import RFC_4122
@_exported public import RFC_9562
@_exported public import Random
