//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension URL {
    @inlinable
    public var folder: Folder? { Folder(url: self) }
}

/// - Note: Equatability does compare `absoluteString` of `url`, not URLs themselves, for better compatibility between different ways to point to the same file.
public struct Folder: Equatable, Sendable, CustomStringConvertible {
    public let url: URL

    @inlinable @inline(__always)
    public var path: String { url.path }

    @inlinable
    public var description: String { "Folder(path=\"\(url.absoluteString)\")" }

    /// Fails when `url` is not pointing to a file URL that is itself a directory.
    @inlinable
    public init?(url: URL) {
        guard url.isFileURL && url.hasDirectoryPath else { return nil }
        self.url = url
    }

    @inlinable
    public func fileURL(filename: Filename, pathExtension: String) -> FileURL {
        return fileURL(basename: Basename(filename: filename, pathExtension: pathExtension))
    }

    @inlinable
    public func fileURL(basename: Basename) -> FileURL {
        return FileURL(folder: self, basename: basename)
    }

    @inlinable
    public static func == (lhs: Folder, rhs: Folder) -> Bool {
        // We compare computed paths, not URL objects, so that `URL(fileURLWithPath: "/foo/bar")` and `URL(fileURLWithPath: "bar", relativeTo: URL(fileURLWithPath: "/foo"))` are treated equally. Same with relative file paths involving `../`.
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
