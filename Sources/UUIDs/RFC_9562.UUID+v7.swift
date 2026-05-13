// RFC_9562.UUID+v7.swift
// L3 binding: `RFC_9562.UUID.v7(unixMilliseconds:)` overload using the platform CSPRNG.

public import RFC_9562
public import Random

extension RFC_9562.UUID {
    /// Generates a version 7 UUID using the platform CSPRNG and a host-supplied
    /// Unix-milliseconds timestamp.
    ///
    /// Binds the parametric `v7(unixMilliseconds:fillRandom:)` generator from
    /// `swift-rfc-9562` (L2) to `Random.fill(_:)` from `swift-random` (L3
    /// platform random). Version 7 UUIDs (RFC 9562 §5.7) combine a 48-bit Unix
    /// timestamp in milliseconds with random data; they are time-ordered and
    /// recommended for new applications.
    ///
    /// - Parameter unixMilliseconds: Unix timestamp in milliseconds since the
    ///   epoch. Must be non-negative and fit in 48 bits
    ///   (0 to 281,474,976,710,655).
    /// - Returns: A version 7 UUID with version 7 and RFC 4122 variant bits set.
    /// - Throws: `Random.Error` if the platform CSPRNG cannot produce random bytes.
    ///
    /// ## Example
    ///
    /// ```swift
    /// import UUIDs
    ///
    /// let now: Int64 = 1645557742000  // 2022-02-22T19:22:22.000Z
    /// let uuid = try RFC_9562.UUID.v7(unixMilliseconds: now)
    /// ```
    public static func v7(unixMilliseconds: Int64) throws(Random.Error) -> Self {
        try unsafe v7(unixMilliseconds: unixMilliseconds, fillRandom: Random.fill)
    }
}
