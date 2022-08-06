//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import Filename

class URL_FilenameTests: XCTestCase {
    func testFilenameHelper() {
        XCTAssertEqual(url("/").filename, "/")
        XCTAssertEqual(URL(fileURLWithPath: "", relativeTo: URL(fileURLWithPath: "/")).filename, "/")
        XCTAssertEqual(url("//").filename, "/")
        XCTAssertEqual(url("test").filename, "test")
        XCTAssertEqual(url("/test/").filename, "test")
        XCTAssertEqual(url("file:///what/where/").filename, "where")
        XCTAssertEqual(url("test/foo").filename, "foo")
        XCTAssertEqual(url(".bar").filename, ".bar")
        XCTAssertEqual(url("foo/.baz").filename, ".baz")
        XCTAssertEqual(url("shmoo/.test/bazz").filename, "bazz")

        XCTAssertEqual(url("fst.txt").filename, "fst")
    }
}
