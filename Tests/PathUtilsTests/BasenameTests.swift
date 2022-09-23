//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class BasenameTests: XCTestCase {
    private func url(_ path: String) -> URL {
        return URL(fileURLWithPath: path)
    }

    func testInitFromURL() {
        XCTAssertEqual(
            Basename(url: url("/foo/bar/banana rama.version.extension")),
            Basename(value: "banana rama.version", pathExtension: "extension"))
        XCTAssertEqual(
            Basename(url: url(".somefoo")),
            Basename(value: ".somefoo", pathExtension: ""))
        XCTAssertNil(Basename(url: URL(fileURLWithPath: "/")))
    }

    func testString() {
        XCTAssertEqual(Basename(value: "the_file", pathExtension: "").string, "the_file")
        XCTAssertEqual(Basename(value: "the_file", pathExtension: "txt").string, "the_file.txt")
        XCTAssertEqual(Basename(value: "the_file", pathExtension: " ").string, "the_file. ",
                       "Nonsensical, but there's no rule against whitespace-only path extensions")
    }

    func testURL() {
        let baseURL = URL(fileURLWithPath: "/base/path/")
        XCTAssertEqual(Basename(value: "file", pathExtension: "ext").url(relativeTo: baseURL).absoluteString,
                       "file:///base/path/file.ext")
        XCTAssertEqual(Basename(value: "file", pathExtension: "").url(relativeTo: baseURL).absoluteString,
                       "file:///base/path/file")
    }
}
