//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.URL

extension URL {
    /// ``FileURL``, if the receiver is pointing to a resource on the local file system.
    @inlinable
    public var fileURL: FileURL? { FileURL(from: self) }
}

/// A URL that points to a resource on the local file system, i.e. via the `file:` scheme. 
public struct FileURL: Equatable {
    public let url: URL

    /// Filename of the file without path extension, so "/path/to/foo.txt" becomes "foo".
    public var filename: Filename? { Filename(url: url) }

    /// Name of the file with path extension, so “/path/to/foo.txt” becomes “foo.txt”.
    public var basename: Basename? { Basename(url: url) }

    /// Folder representation of the `url`'s parent path component.
    public var folder: Folder? {
        Folder(url: url.deletingLastPathComponent()) }

    public init(folder: Folder, basename: Basename) {
        let url = basename.url(relativeTo: folder)
        assert(url.isFileURL, "Folder guarantees isFileURL already, adding a Basename should not alter that.")
        assert(!url.hasDirectoryPath, "Basename inside Folder should not produce a directory path.")
        self.url = url
    }

    /// - Invariant: Cannot be constructed for non-file-URLs. Adheres to the rules of  `URL.isFileURL` combined with `URL.hasDirectoryPath`.
    public init?(from url: URL) {
        guard url.isFileURL,
              !url.hasDirectoryPath
        else { return nil }
        self.url = url
    }
}
