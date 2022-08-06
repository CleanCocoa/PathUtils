//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension URL {
    /// Filename without path extension of the last path component.
    public var filename: String {
        return (self.lastPathComponent as NSString)
            .deletingPathExtension
            // Favor simple characters over combined grapheme clusters
            .precomposedStringWithCanonicalMapping
    }
}

/// Representation of a filename sans path or extension. So "/path/to/foo.txt" becomes just "foo".
///
/// See ``Basename`` for filename with a path extension.
public struct Filename: Equatable, Hashable, CustomStringConvertible {
    public let value: ContentfulString
    public var string: String { return value.value }

    public init(_ value: ContentfulString) {
        self.value = value
    }

    public init?(string: String) {
        guard let contentful = ContentfulString(string) else { return nil }
        self.value = contentful
    }

    public init?(url: URL) {
        // Empty root path
        guard url.filename != "/" else { return nil }
        self.init(string: url.filename)
    }

    public func url(relativeTo url: URL, pathExtension: String) -> URL {

        return url.appendingPathComponent(self.string)
            .appendingPathExtension(pathExtension)
    }

    public func url(relativeTo folder: Folder, pathExtension: String) -> URL {

        return url(relativeTo: folder.url,
                   pathExtension: pathExtension)
    }

    public var description: String {
        return "Filename(\(value))"
    }
}

public func + (lhs: Filename, rhs: String) -> Filename {
    return Filename(lhs.value + rhs)
}

extension Filename: Comparable { }

public func < (lhs: Filename, rhs: Filename) -> Bool {
    return lhs.value < rhs.value
}
