// RFC_4122.UUID+v4.swift
// L3 binding: `RFC_4122.UUID.v4()` parameterless overload using the platform CSPRNG.

public import RFC_4122
public import Random

extension RFC_4122.UUID {
    /// Generates a version 4 (random) UUID using the platform CSPRNG.
    ///
    /// Binds the parametric `v4(fillRandom:)` generator from `swift-rfc-4122`
    /// (L2) to `Random.fill(_:)` from `swift-random` (L3 platform random),
    /// composing the spec-faithful RFC 4122 §4.4 encoding with the platform's
    /// cryptographically-secure random source:
    /// - Darwin: `arc4random_buf`
    /// - Linux: `getrandom(2)` (with `EINTR` retry, `EAGAIN` → `entropyNotReady`)
    /// - Windows: `BCryptGenRandom`
    ///
    /// - Returns: A version 4 UUID with version 4 and RFC 4122 variant bits set.
    /// - Throws: `Random.Error` if the platform CSPRNG cannot produce random bytes.
    ///
    /// ## Example
    ///
    /// ```swift
    /// import UUIDs
    ///
    /// let uuid = try RFC_4122.UUID.v4()
    /// print(uuid.version)  // Optional(.v4)
    /// ```
    public static func v4() throws(Random.Error) -> Self {
        try unsafe v4(fillRandom: Random.fill)
    }
}
