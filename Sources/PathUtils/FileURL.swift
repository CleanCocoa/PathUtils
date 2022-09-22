//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.URL

extension URL {
    /// ``FileURL``, if the receiver is pointing to a resource on the local file system.
    @inlinable
    public var fileURL: FileURL? { FileURL(from: self) }
}

/// A URL that points to a resource on the local file system, i.e. via the `file:` scheme. 
public struct FileURL: Equatable {
    /// Folder representation of the file's URL up to (but excluding) the file.
    public let folder: Folder

    /// Basename of the file with path extension, so "/path/to/foo.txt" becomes "foo.txt".
    public let basename: Basename

    /// Filename of the file without path extension, so "/path/to/foo.txt" becomes "foo".
    public var filename: Filename { basename.filename }

    /// Absolute URL of the file.
    public var url: URL { basename.url(relativeTo: folder) }

    public init(folder: Folder, basename: Basename) {
        self.folder = folder
        self.basename = basename
    }

    /// - Invariant: Cannot be constructed for non-file-URLs. Adheres to the rules of  `URL.isFileURL` combined with `URL.hasDirectoryPath`.
    public init?(from url: URL) {
        guard url.isFileURL,
              !url.hasDirectoryPath,
              // A file URL that is not a directory path always has a lastPathComponent (the file); the root `/` would have exited at this point.
              let basename = Basename(url: url),
              let folder = Folder(url: url.deletingLastPathComponent())
        else { return nil }
        self.init(folder: folder, basename: basename)
    }
}
