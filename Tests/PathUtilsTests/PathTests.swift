//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

final class PathTests: XCTestCase {
    func testFolderAndFilenameConcatenation() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to/success/")))
        let filename = Filename(try XCTUnwrap(contentful("the file")))

        XCTAssertEqual((folder + filename) as String,
                       "/path/to/success/the file")
        XCTAssertEqual((folder + filename) as FileURL,
                       try XCTUnwrap(FileURL(from: URL(fileURLWithPath: "/path/to/success/the file"))))
    }

    func testFolderAndBasenameConcatenation() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to/success/")))
        let filename = Filename(try XCTUnwrap(contentful("the file")))
        let basename = Basename(filename: filename, pathExtension: "txt")

        XCTAssertEqual((folder + basename) as String,
                       "/path/to/success/the file.txt")
        XCTAssertEqual((folder + basename) as FileURL,
                       try XCTUnwrap(FileURL(folder: folder, basename: basename)))
    }
}
