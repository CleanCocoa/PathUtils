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

    func testInitFromString() {
        XCTAssertNil(Basename(string: ""))

        XCTAssertEqual(Basename(string: "."), Basename(value: ".", pathExtension: ""))
        XCTAssertEqual(Basename(string: ".."), Basename(value: "..", pathExtension: ""))
        XCTAssertEqual(Basename(string: "....."), Basename(value: ".....", pathExtension: ""))

        XCTAssertEqual(Basename(string: " "), Basename(value: " ", pathExtension: ""))
        XCTAssertEqual(Basename(string: "test"), Basename(value: "test", pathExtension: ""))
        
        XCTAssertEqual(Basename(string: ".hidden"), Basename(value: ".hidden", pathExtension: ""))
        XCTAssertEqual(Basename(string: ".hidden.file"), Basename(value: ".hidden", pathExtension: "file"))

        XCTAssertEqual(Basename(string: "abnormal....file"), Basename(value: "abnormal...", pathExtension: "file"))

        XCTAssertEqual(Basename(string: "normal.file"), Basename(value: "normal", pathExtension: "file"))
        XCTAssertEqual(Basename(string: "a.b.c"), Basename(value: "a.b", pathExtension: "c"))
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

    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let basename = Basename(
            filename: try XCTUnwrap(Filename(string: ".top.secret")),
            pathExtension: "gpg"
        )

        let jsonData = try encoder.encode(basename)
        XCTAssertEqual(String(data: jsonData, encoding: .utf8), #"".top.secret.gpg""#)

        let decoded = try decoder.decode(Basename.self, from: jsonData)
        XCTAssertEqual(decoded, basename)
    }
}
