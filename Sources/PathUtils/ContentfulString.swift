//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation  // for String.contains(_:) that takes another String

@inlinable
public func contentful(_ string: String?) -> ContentfulString? {
    guard let string = string else { return nil }
    return ContentfulString(string)
}

@inlinable
public func contentful(_ string: String) -> ContentfulString? {
    return ContentfulString(string)
}

@inlinable
public func contentful(_ strings: [String]?) -> [ContentfulString] {
    guard let strings = strings else { return [] }
    return strings.compactMap(contentful)
}

public struct ContentfulString: Equatable, Hashable, Sendable, CustomStringConvertible {
    public let value: String

    @inlinable
    public init?(_ value: String) {
        guard !value.isEmpty else { return nil }
        self.value = value
    }

    public var description: String { return value.description }

    @inlinable
    public func prepending(_ string: String) -> ContentfulString {
        return ContentfulString(string + value)!
    }

    @inlinable
    public func appending(_ string: String) -> ContentfulString {
        return ContentfulString(value + string)!
    }

    @inlinable
    public func contains(_ string: String) -> Bool {
        return value.contains(string)
    }

    @inlinable
    public func lowercased() -> ContentfulString {
        return ContentfulString(value.lowercased())!  // Force-try guaranteed to succeed because `self.value` cannot be empty.
    }
}

extension ContentfulString: Comparable {
    @inlinable
    public static func < (
        lhs: ContentfulString,
        rhs: ContentfulString
    ) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: Concatenation

@inlinable
public func + (lhs: ContentfulString, rhs: String) ->
  ContentfulString {
    return lhs.appending(rhs)
}

@inlinable
public func + (lhs: String, rhs: ContentfulString) -> ContentfulString {
    return rhs.prepending(lhs)
}

@inlinable
public func + (lhs: ContentfulString, rhs: ContentfulString) -> ContentfulString {
    return lhs.appending(rhs.value)
}

@inlinable
public func + (lhs: ContentfulString, rhs: ContentfulString?) -> ContentfulString {
    guard let rhs = rhs else { return lhs }
    return lhs + rhs
}
