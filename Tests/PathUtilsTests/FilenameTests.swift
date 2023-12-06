//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

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

    func testURL() {
        let filename = Filename("the-file")
        let baseURL = URL(fileURLWithPath: "/base/path/")
        XCTAssertEqual(filename.url(relativeTo: baseURL, pathExtension: "").absoluteString,
                       "file:///base/path/the-file")
        XCTAssertEqual(filename.url(relativeTo: baseURL, pathExtension: "ext").absoluteString,
                       "file:///base/path/the-file.ext")
    }

    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let filename = try XCTUnwrap(Filename(string: "Test Filename"))

        let jsonData = try encoder.encode(filename)
        XCTAssertEqual(String(data: jsonData, encoding: .utf8), #""Test Filename""#)

        let decoded = try decoder.decode(Filename.self, from: jsonData)
        XCTAssertEqual(decoded, filename)
    }
}
