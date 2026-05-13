// UUIDs Tests.swift

import Testing
@testable import UUIDs

extension UUIDs {
    enum Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
    }
}

// Test namespace for organizing UUIDs tests.
public enum UUIDs {}

// MARK: - Unit Tests — v4

extension UUIDs.Test.Unit {
    @Test
    func `v4() returns a UUID with version 4 bits set`() throws {
        let uuid = try RFC_4122.UUID.v4()
        // Version 4 is encoded in the high nibble of byte 6.
        #expect((uuid.bytes.6 & 0xF0) == 0x40)
    }

    @Test
    func `v4() returns a UUID with RFC 4122 variant bits set`() throws {
        let uuid = try RFC_4122.UUID.v4()
        // RFC 4122 variant is encoded in the high 2 bits of byte 8.
        #expect((uuid.bytes.8 & 0xC0) == 0x80)
    }

    @Test
    func `v4() returns different UUIDs on successive calls`() throws {
        let first = try RFC_4122.UUID.v4()
        let second = try RFC_4122.UUID.v4()
        // Two 122-bit random values are statistically certain to differ.
        #expect(first != second)
    }
}

// MARK: - Unit Tests — v7

extension UUIDs.Test.Unit {
    @Test
    func `v7(unixMilliseconds:) encodes the timestamp in big-endian bytes 0-5`() throws {
        let timestamp: Int64 = 0x0123_4567_89AB
        let uuid = try RFC_9562.UUID.v7(unixMilliseconds: timestamp)
        #expect(uuid.bytes.0 == 0x01)
        #expect(uuid.bytes.1 == 0x23)
        #expect(uuid.bytes.2 == 0x45)
        #expect(uuid.bytes.3 == 0x67)
        #expect(uuid.bytes.4 == 0x89)
        #expect(uuid.bytes.5 == 0xAB)
    }

    @Test
    func `v7(unixMilliseconds:) sets version 7 bits`() throws {
        let uuid = try RFC_9562.UUID.v7(unixMilliseconds: 0)
        // Version 7 is encoded in the high nibble of byte 6.
        #expect((uuid.bytes.6 & 0xF0) == 0x70)
    }

    @Test
    func `v7(unixMilliseconds:) sets RFC 4122 variant bits`() throws {
        let uuid = try RFC_9562.UUID.v7(unixMilliseconds: 0)
        #expect((uuid.bytes.8 & 0xC0) == 0x80)
    }

    @Test
    func `v7(unixMilliseconds:) is monotone in the timestamp`() throws {
        // Two UUIDs produced with monotone timestamps must order such that the
        // earlier timestamp's UUID is lexicographically smaller in its
        // timestamp prefix.
        let earlier = try RFC_9562.UUID.v7(unixMilliseconds: 1_000_000_000_000)
        let later = try RFC_9562.UUID.v7(unixMilliseconds: 1_000_000_000_001)
        // Compare the 6-byte timestamp prefix.
        let earlierPrefix: [UInt8] = [
            earlier.bytes.0, earlier.bytes.1, earlier.bytes.2,
            earlier.bytes.3, earlier.bytes.4, earlier.bytes.5,
        ]
        let laterPrefix: [UInt8] = [
            later.bytes.0, later.bytes.1, later.bytes.2,
            later.bytes.3, later.bytes.4, later.bytes.5,
        ]
        #expect(earlierPrefix.lexicographicallyPrecedes(laterPrefix))
    }
}

// MARK: - Edge Cases

extension UUIDs.Test.EdgeCase {
    @Test
    func `v7(unixMilliseconds:) accepts the 48-bit maximum`() throws {
        let max48: Int64 = 0xFFFF_FFFF_FFFF
        let uuid = try RFC_9562.UUID.v7(unixMilliseconds: max48)
        #expect(uuid.bytes.0 == 0xFF)
        #expect(uuid.bytes.5 == 0xFF)
    }

    @Test
    func `v4() and v7() produce distinguishable versions`() throws {
        let four = try RFC_4122.UUID.v4()
        let seven = try RFC_9562.UUID.v7(unixMilliseconds: 0)
        #expect((four.bytes.6 & 0xF0) != (seven.bytes.6 & 0xF0))
    }
}
