//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation  // for String.contains(_:) that takes another String

public func contentful(_ string: String?) -> ContentfulString? {
    guard let string = string else { return nil }
    return ContentfulString(string)
}

public func contentful(_ string: String) -> ContentfulString? {
    return ContentfulString(string)
}

public func contentful(_ strings: [String]?) -> [ContentfulString] {
    guard let strings = strings else { return [] }
    return strings.compactMap(contentful)
}

public struct ContentfulString: Equatable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let value: String

    public init(stringLiteral value: String) {
        self.init(value)!
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)!
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)!
    }

    public init?(_ value: String) {
        guard !value.isEmpty else { return nil }
        self.value = value
    }

    public var description: String { return value.description }

    public func prepending(_ string: String) -> ContentfulString {
        return ContentfulString(string + value)!
    }

    public func appending(_ string: String) -> ContentfulString {
        return ContentfulString(value + string)!
    }

    public func contains(_ string: String) -> Bool {
        return value.contains(string)
    }

    public func lowercased() -> String {
        return value.lowercased()
    }
}

extension ContentfulString: Comparable {
    public static func < (lhs: ContentfulString, rhs: ContentfulString) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: Concatenation

public func + (lhs: ContentfulString, rhs: String) ->
  ContentfulString {
    return lhs.appending(rhs)
}

public func + (lhs: String, rhs: ContentfulString) -> ContentfulString {
    return rhs.prepending(lhs)
}

public func + (lhs: ContentfulString, rhs: ContentfulString) -> ContentfulString {
    return lhs.appending(rhs.value)
}

public func + (lhs: ContentfulString, rhs: ContentfulString?) -> ContentfulString {
    guard let rhs = rhs else { return lhs }
    return lhs + rhs
}
