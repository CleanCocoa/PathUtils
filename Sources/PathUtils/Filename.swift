//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension URL {
    /// ``Filename``, without path extension of the last path component.
    @inlinable
    public var filename: Filename? { Filename(url: self) }

    /// Canonical version of the last path component without path extension.
    public var filenamePathComponent: String {
        return (self.lastPathComponent as NSString)
            .deletingPathExtension
            // Favor simple characters over combined grapheme clusters
            .precomposedStringWithCanonicalMapping
    }
}

/// Representation of a filename sans path or extension. So "/path/to/foo.txt" becomes just "foo".
///
/// See ``Basename`` for filename with a path extension.
public struct Filename: Equatable, Hashable, Sendable, CustomStringConvertible {
    public let value: ContentfulString
    @inlinable @inline(__always)
    public var string: String { value.value }

    @inlinable
    public var description: String { "Filename(\(value))" }

    @inlinable
    public init(_ value: ContentfulString) {
        self.value = value
    }

    @inlinable @inline(__always)
    public init?(string: String) {
        guard let contentful = ContentfulString(string) else { return nil }
        self.value = contentful
    }

    @inlinable @inline(__always)
    public init?(url: URL) {
        let filename = url.filenamePathComponent

        // Empty root path is just the slash.
        guard filename != "/" else { return nil }
        self.init(string: filename)
    }

    @inlinable
    public func url(relativeTo url: URL, pathExtension: String = "") -> URL {
        return url.appendingPathComponent(self.string)
            .appendingPathExtension(pathExtension)
    }

    @inlinable
    public func url(relativeTo folder: Folder, pathExtension: String = "") -> URL {
        return url(relativeTo: folder.url,
                   pathExtension: pathExtension)
    }

    @inlinable
    public func fileURL(relativeTo folder: Folder, pathExtension: String = "") -> FileURL {
        return folder.fileURL(filename: self, pathExtension: pathExtension)
    }
}

@inlinable
public func + (lhs: Filename, rhs: String) -> Filename {
    return Filename(lhs.value + rhs)
}

extension Filename: Comparable {
    @inlinable
    public static func < (lhs: Filename, rhs: Filename) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Filename: Decodable {
    public enum DecodingError: Error {
         /// Indicates that `""` was tried to be parsed.
        case emptyFilename
    }

    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let fullString = try container.decode(String.self)

        let pathComponents = (fullString as NSString).pathComponents
        guard let lastComponent = pathComponents.last,
              let contentfulString = ContentfulString(String(lastComponent)) else {
            throw DecodingError.emptyFilename
        }

        self.init(contentfulString)
    }
}

extension Filename: Encodable {
    @inlinable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
