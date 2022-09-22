//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class URL_FilenameTests: XCTestCase {
    func testFilenameHelper() {
        XCTAssertEqual(url("/").filenamePathComponent, "/")
        XCTAssertEqual(URL(fileURLWithPath: "", relativeTo: URL(fileURLWithPath: "/")).filenamePathComponent, "/")
        XCTAssertEqual(url("//").filenamePathComponent, "/")
        XCTAssertEqual(url("test").filenamePathComponent, "test")
        XCTAssertEqual(url("/test/").filenamePathComponent, "test")
        XCTAssertEqual(url("file:///what/where/").filenamePathComponent, "where")
        XCTAssertEqual(url("test/foo").filenamePathComponent, "foo")
        XCTAssertEqual(url(".bar").filenamePathComponent, ".bar")
        XCTAssertEqual(url("foo/.baz").filenamePathComponent, ".baz")
        XCTAssertEqual(url("shmoo/.test/bazz").filenamePathComponent, "bazz")

        XCTAssertEqual(url("fst.txt").filenamePathComponent, "fst")
        XCTAssertEqual(url("arch.tar.gz").filenamePathComponent, "arch.tar")
    }
}
