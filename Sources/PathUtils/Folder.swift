//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

/// - Note: Equatability does compare `absoluteString` of `url`, not URLs themselves, for better compatibility between different ways to point to the same file.
public struct Folder: CustomStringConvertible {
    public let url: URL

    public init?(url: URL) {
        guard url.hasDirectoryPath else { return nil }
        self.url = url
    }

    public var description: String {
        return "Folder(path=\"\(url.path)\")"
    }
}

extension Folder: Equatable {
    public static func == (lhs: Folder, rhs: Folder) -> Bool {
        // We compare computed paths, not URL objects, so that `URL(fileURLWithPath: "/foo/bar")` and `URL(fileURLWithPath: "bar", relativeTo: URL(fileURLWithPath: "/foo"))` are treated equally. Same with relative file paths involving `../`.
        return lhs.url.absoluteString == rhs.url.absoluteString
    }
}
