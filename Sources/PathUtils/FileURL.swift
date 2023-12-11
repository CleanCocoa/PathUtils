//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.URL

extension URL {
    /// ``FileURL``, if the receiver is pointing to a resource on the local file system.
    ///
    /// > Note: Use ``FileURL/init(from:)`` to handle thrown failures.
    @inlinable
    public var fileURL: FileURL? { try? FileURL(from: self) }
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
}

extension FileURL {
    public enum InitFromURLError: Error {
        public enum Unexpected {
            case basenameExtraction
            case folderExtraction
        }

        case notFileURL(URL)
        case isDirectory(URL)

        /// Indicates unexpected failure at known points.
        case unexpected(Unexpected, URL)
    }

    /// - Invariant: Cannot be constructed for non-file-URLs. Adheres to the rules of  `URL.isFileURL` combined with `URL.hasDirectoryPath`.
    public init(from url: URL) throws {
        guard url.isFileURL else { throw InitFromURLError.notFileURL(url) }
        guard !url.hasDirectoryPath else { throw InitFromURLError.isDirectory(url) }
        // A file URL that is not a directory path always has a lastPathComponent (the file); the root `/` would have exited at this point.
        guard let basename = Basename(url: url) else { throw InitFromURLError.unexpected(.basenameExtraction, url) }
        guard let folder = Folder(url: url.deletingLastPathComponent()) else { throw InitFromURLError.unexpected(.folderExtraction, url) }
        self.init(folder: folder, basename: basename)
    }
}

extension FileURL: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let url = try container.decode(URL.self)
        let fileURL = try FileURL(from: url)
        self = fileURL
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(url)
    }
}
