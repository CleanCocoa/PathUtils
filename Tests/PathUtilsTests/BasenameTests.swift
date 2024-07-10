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

        let pairs: [(input: String, expectedValue: ContentfulString, expectedPathExtension: String)] = [
            (".",                 ".", ""),
            ("..",                "..", ""),
            (".....",             ".....", ""),
            (" ",                 " ", ""),
            ("test",              "test", ""),
            (".hidden",           ".hidden", ""),
            (".hidden.file",      ".hidden", "file"),
            ("abnormal....file",  "abnormal...", "file"),
            ("normal.file",       "normal", "file"),
            ("a.b.c",             "a.b", "c"),
        ]
        for (input, expectedValue, expectedPathExtension) in pairs {
            XCTAssertEqual(Basename(string: input), Basename(value: expectedValue, pathExtension: expectedPathExtension))
        }

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

    func testCodable_Roundtrip() throws {
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

    func testDecodable() throws {
        let decoder = JSONDecoder()

        func decoded(_ jsonString: String) throws -> Basename {
            try decoder.decode(Basename.self, from: jsonString.data(using: .utf8)!)
        }

        // Valid JSON requires enquoting
        XCTAssertThrowsError(try decoded(#"file"#))
        XCTAssertThrowsError(try decoded(#"text.txt"#))

        XCTAssertThrowsError(try decoded(#""#))
        XCTAssertThrowsError(try decoded(#""""#))

        let pairs: [(input: String, expectedValue: ContentfulString, expectedPathExtension: String)] = [
            (#""text.txt""#,                   "text", "txt"),
            (#""file""#,                       "file", ""),
            (#"".top.secret.gpg""#,            ".top.secret", "gpg"),
            (#""/doc.txt""#,                   "doc", "txt"),
            (#""relative/doc.txt""#,           "doc", "txt"),
            (#""/absolute/doc.txt""#,          "doc", "txt"),
            (#""file:///full/path/doc.txt""#,  "doc", "txt"),
        ]
        for (input, expectedValue, expectedPathExtension) in pairs {
            try XCTAssertEqual(decoded(input), Basename(value: expectedValue, pathExtension: expectedPathExtension))
        }
    }
}
