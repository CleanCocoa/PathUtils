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
///
/// ## Decoding
///
/// By default, ``FileURL`` decodes from `Foundation.URL` and interprets the result in ``FileURL/init(from:)`` as usual.
///
/// When decoding user data, though, you may want to interpret paths as file URLs as well. To decode ``FileURL`` from file paths like "`/tmp/doc.txt`", configure the `Decoder` to use `CodingUserInfoKey.readFileURLFromPath`:
///
/// ```swift
/// decoder.userInfo[.readFileURLFromPath] = true
/// ```
///
/// This will replace treating the path  "`/tmp/doc.txt`" as a scheme-less `URL(string: "/tmp/doc.txt")` with treating it as `URL(string: "file:///tmp/doc.txt")`.
///
/// **Make sure you resolve paths that make sense to your context.** Note that the default behavior of `Foundation.URL`'s relative path resolution applies. A relative path will be resolved against the default URL path in context. E.g. in tests, that's `file:///private/tmp/`. You may want to provide a static base URL for this instead:
///
/// ```swift
/// decoder.userInfo[.fileURLBaseURL] = URL(filePath: ...)
/// ```
///
/// Or if you prefer manual conversion:
///
/// ```swift
/// let baseURL: URL = ...
/// let decodedFileURL: FileURL = ...
/// let rebasedURL = URL(filePath: decodedFileURL.url.path, relativeTo: baseURL)
/// let rebasedFileURL = try FileURL(from: rebasedURL)
/// ```
public struct FileURL: Equatable, Sendable {
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

extension CodingUserInfoKey {
    /// Determines if URL decoding should treat a path without any scheme as a `file://` URL during ``FileURL/init(from:)``.
    ///
    /// Set the base URL resolution via `fileURLBaseURL`.
    /// 
    /// - Invariant: Associated value is expected to be a `Bool`.
    public static let readFileURLFromPath: CodingUserInfoKey = {
        guard let key = CodingUserInfoKey(rawValue: "FileURL_readFileURLFromPath") else {
            fatalError("CodingUserInfoKey.init failed for nonempty string")
        }
        return key
    }()

    /// The base URL to resolve relative paths against when `readFileURLFromPath` is set.
    /// - Invariant: Associated value is expected to be a `URL`.
    public static let fileURLBaseURL: CodingUserInfoKey = {
        guard let key = CodingUserInfoKey(rawValue: "FileURL_fileURLBaseURL") else {
            fatalError("CodingUserInfoKey.init failed for nonempty string")
        }
        return key
    }()
}

extension FileURL: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let decodedURL = try container.decode(URL.self)
        let url: URL = {
            // "/path/to/file.txt" decodes into a URL without scheme.
            if decodedURL.scheme == nil,
               let readFileURLFromPath = decoder.userInfo[.readFileURLFromPath] as? Bool,
               readFileURLFromPath == true {
                let baseURL = decoder.userInfo[.fileURLBaseURL] as? URL
                if #available(macOS 13.0, *) {
                    return URL(filePath: decodedURL.path, relativeTo: baseURL)
                } else {
                    return URL(fileURLWithPath: decodedURL.path, relativeTo: baseURL)
                }
            } else {
                return decodedURL
            }
        }()

        let fileURL = try FileURL(from: url)
        self = fileURL
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(url)
    }
}
