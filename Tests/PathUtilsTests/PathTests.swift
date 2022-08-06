//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

final class PathTests: XCTestCase {
    func testFolderAndFilenameConcatenation() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to/success/")))
        let filename = Filename(try XCTUnwrap(contentful("the file")))

        XCTAssertEqual(folder + filename,
                       "/path/to/success/the file")
    }

    func testFolderAndBasenameConcatenation() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to/success/")))
        let filename = Filename(try XCTUnwrap(contentful("the file")))
        let basename = Basename(filename: filename, pathExtension: "txt")

        XCTAssertEqual(folder + basename,
                       "/path/to/success/the file.txt")
    }
}
