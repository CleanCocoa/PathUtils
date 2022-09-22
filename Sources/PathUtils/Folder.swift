//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension URL {
    public var folder: Folder? { Folder(url: self) }
}

/// - Note: Equatability does compare `absoluteString` of `url`, not URLs themselves, for better compatibility between different ways to point to the same file.
public struct Folder: Equatable, CustomStringConvertible {
    public let url: URL
    public var path: String { url.path }

    /// Fails when `url` is not pointing to a file URL that is itself a directory.
    public init?(url: URL) {
        guard url.isFileURL && url.hasDirectoryPath else { return nil }
        self.url = url
    }

    public var description: String {
        return "Folder(path=\"\(url.path)\")"
    }

    public static func == (lhs: Folder, rhs: Folder) -> Bool {
        // We compare computed paths, not URL objects, so that `URL(fileURLWithPath: "/foo/bar")` and `URL(fileURLWithPath: "bar", relativeTo: URL(fileURLWithPath: "/foo"))` are treated equally. Same with relative file paths involving `../`.
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
