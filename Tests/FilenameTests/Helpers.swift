//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

@testable import Filename

func url(_ path: String) -> URL {
    return URL(fileURLWithPath: path)
}

extension ContenfulString: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)!
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)!
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)!
    }
}

extension Basename {
    init(value: ContentfulString, pathExtension: String) {
        self.init(filename: Filename(value), pathExtension: pathExtension)
    }

    init?(string: String, pathExtension: String) {
        guard let filename = Filename(string: string) else { return nil }
        self.init(filename: filename, pathExtension: pathExtension)
    }
}
