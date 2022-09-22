//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.URL

extension URL {
    /// ``FileURL``, if the receiver is pointing to a resource on the local file system.
    @inlinable
    public var fileURL: FileURL? { FileURL(from: self) }
}

/// A URL that points to a resource on the local file system, i.e. via the `file:` scheme. 
/// - Invariant: Cannot be constructed for non-file-URLs. Adheres to the same rules as  ``URL.isFileURL``.
public struct FileURL: Equatable {
    public let url: URL

    /// Filename of the file without path extension, so "/path/to/foo.txt" becomes "foo".
    public var filename: Filename? { Filename(url: url) }

    /// Name of the file with path extension, so “/path/to/foo.txt” becomes “foo.txt”.
    public var basename: Basename? { Basename(url: url) }

    /// Folder representation of the `url`'s parent path component.
    public var folder: Folder? {
        Folder(url: url.deletingLastPathComponent()) }

    public init?(from url: URL) {
        guard url.isFileURL,
              !url.hasDirectoryPath
        else { return nil }
        self.url = url
    }
}
