//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension URL {
    /// ``Basename`` with file extension of the last path component.
    @inlinable
    public var basename: Basename? { Basename(url: self) }
}

/// Representation of a filename with its path extension. So "/path/to/foo.txt" becomes "foo.txt".
///
/// See ``Filename`` for filename without path extension.
public struct Basename: Equatable, Hashable {
    public let filename: Filename
    /// When the file has no path extension, an empty string.
    public let pathExtension: String

    public var string: String {
        let suffix = pathExtension.isEmpty
            ? ""
            : ".\(pathExtension)"
        return filename.string + suffix
    }

    public init(filename: Filename,
                pathExtension: String) {
        self.filename = filename
        self.pathExtension = pathExtension
    }

    public init?(url: URL) {
        guard let filename = Filename(url: url) else { return nil}
        self.init(filename: filename,
                  pathExtension: url.pathExtension)
    }

    public func url(relativeTo url: URL) -> URL {
        return filename.url(
           relativeTo: url,
           pathExtension: self.pathExtension)
    }

    public func url(relativeTo folder: Folder) -> URL {
        return filename.url(
            relativeTo: folder,
            pathExtension: pathExtension)
    }

    public func fileURL(relativeTo folder: Folder) -> FileURL {
        return folder.fileURL(basename: self)
    }
}

extension Basename: CustomStringConvertible {
    public var description: String { "Basename(\(filename) . \(pathExtension))" }
}

extension Basename {
    private static func splitBasename(
        _ string: String
    ) -> (filename: String, pathExtension: String?) {
        // "." and ".." but also "....."
        if string.allSatisfy({ $0 == "." }) {
            return (string, nil)
        }

        let lastIndex = string.lastIndex(of: ".") ?? string.endIndex
        guard lastIndex != string.startIndex else {
            return (string, nil)
        }
        let filename = String(string[..<lastIndex])
        let hasExtension = lastIndex != string.endIndex

        return hasExtension ? (filename, String(string[string.index(after: lastIndex)...])) : (string, nil)
    }

    public init?(string: String) {
        let (filenameString, pathExtension) = Self.splitBasename(string)

        guard let filename = Filename(string: filenameString) else { return nil }

        self.init(
            filename: filename,
            pathExtension: pathExtension ?? ""
        )
    }
}
