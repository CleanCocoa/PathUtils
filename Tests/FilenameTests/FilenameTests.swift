//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import Filename

class FilenameTests: XCTestCase {
    func testInitFromString() {
        XCTAssertNil(Filename(string: ""))
        XCTAssertEqual(Filename(string: " ")?.string, " ")
    }

    func testInitFromURL() {
        XCTAssertEqual(
            Filename(url: url("/foo/bar/banana rama.version.extension")),
            Filename("banana rama.version"))
        XCTAssertEqual(
            Filename(url: url(".somefoo")),
            Filename(".somefoo"))
        XCTAssertNil(Filename(url: URL(fileURLWithPath: "/")))
    }

    func testFilename_EdgeCases() {
        XCTAssertEqual(url("arch.tar.gz").filename, "arch.tar")
    }

    func testURL() {
        let filename = Filename("the-file")
        let baseURL = URL(fileURLWithPath: "/base/path/")
        XCTAssertEqual(filename.url(relativeTo: baseURL, pathExtension: "").absoluteString,
                       "file:///base/path/the-file")
        XCTAssertEqual(filename.url(relativeTo: baseURL, pathExtension: "ext").absoluteString,
                       "file:///base/path/the-file.ext")
    }
}
