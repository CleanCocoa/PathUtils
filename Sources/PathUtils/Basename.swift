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
    public var description: String {
        let suffix = pathExtension.isEmpty
            ? ""
            : ".\(pathExtension)"
        return "Basename(\(filename.string)\(suffix))"
    }
}
