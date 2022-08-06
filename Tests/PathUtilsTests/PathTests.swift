//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

final class PathTests: XCTestCase {
    func testFolderAndFilenameConcatenation() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to/success/")))
        let filename = Filename(try XCTUnwrap(contentful("the file.txt")))

        XCTAssertEqual(folder + filename,
                       "file:///path/to/success/the%20file.txt")
    }
}
