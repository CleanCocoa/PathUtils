//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class FileURLTests: XCTestCase {
    func test_FromFolderAndBasename() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to", isDirectory: true)))
        let basename = Basename(filename: Filename("file"), pathExtension: "txt")
        let fileURL = FileURL(folder: folder, basename: basename)

        XCTAssertEqual(fileURL.folder, folder)
        XCTAssertEqual(fileURL.basename, basename)
        XCTAssertEqual(fileURL.filename, basename.filename)
        XCTAssertEqual(fileURL.url, URL(fileURLWithPath: "/path/to/file.txt"))
    }

    func test_FromHTTP_URL_FailsInitialization() {
        let httpURL = URL(string: "http://web.addres.se")!
        XCTAssertThrowsError(try FileURL(from: httpURL)) { error in
            switch error {
            case FileURL.InitFromURLError.notFileURL(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromHTTPS_URL_FailsInitialization() {
        let httpsURL = URL(string: "https://web.addres.se")!
        XCTAssertThrowsError(try FileURL(from: httpsURL)) { error in
            switch error {
            case FileURL.InitFromURLError.notFileURL(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromFTP_URL_FailsInitialization() {
        let ftpURL = URL(string: "ftp://web.addres.se")!
        XCTAssertThrowsError(try FileURL(from: ftpURL)) { error in
            switch error {
            case FileURL.InitFromURLError.notFileURL(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromSSH_URL_FailsInitialization() {
        let sshURL = URL(string: "ssh://foo:bar@web.addres.se")!
        XCTAssertThrowsError(try FileURL(from: sshURL)) { error in
            switch error {
            case FileURL.InitFromURLError.notFileURL(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromCustomURL_FailsInitialization() {
        let customURL = URL(string: "myapp://host/path")!
        XCTAssertThrowsError(try FileURL(from: customURL)) { error in
            switch error {
            case FileURL.InitFromURLError.notFileURL(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromDirectoryURL_FailsInitialization() {
        let directoryURL = URL(fileURLWithPath: "/xyz", isDirectory: true)
        XCTAssertThrowsError(try FileURL(from: directoryURL)) { error in
            switch error {
            case FileURL.InitFromURLError.isDirectory(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromRootPathURL_FailsInitialization() {
        let rootURL = URL(fileURLWithPath: "/")
        XCTAssertThrowsError(try FileURL(from: rootURL)) { error in
            switch error {
            case FileURL.InitFromURLError.isDirectory(_): break
            default: XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func test_FromAbsoluteFileURL() throws {
        let fileURLFromFile = try FileURL(from: XCTUnwrap(URL(string: "file:///tmp/foo.bar")))

        XCTAssertEqual(fileURLFromFile.filename,
                       Filename("foo"))
        XCTAssertEqual(fileURLFromFile.basename,
                       Basename(filename: Filename("foo"),
                                pathExtension: "bar"))
        XCTAssertEqual(fileURLFromFile.folder,
                       try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/tmp", isDirectory: true))))
    }

    func test_FromAbsoluteFileURLAtRootLevel() throws {
        let fileURL = try FileURL(from: XCTUnwrap(URL(fileURLWithPath: "/root.xyz")))

        XCTAssertEqual(fileURL.filename,
                       Filename("root"))
        XCTAssertEqual(fileURL.basename,
                       Basename(filename: Filename("root"),
                                pathExtension: "xyz"))
        XCTAssertEqual(fileURL.folder,
                       try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/", isDirectory: true))))
    }

    func test_FromRelativeFileURL_WithSubdirectory() throws{
        let relativeFileURL = URL(
            fileURLWithPath: "subdir/file.txt",
            relativeTo: URL(fileURLWithPath: "/tmp/relative/"))
        let fileURLFromRelativeFile = try FileURL(from: relativeFileURL)

        XCTAssertEqual(fileURLFromRelativeFile.basename,
                       Basename(filename: Filename("file"),
                               pathExtension: "txt"))
        XCTAssertEqual(fileURLFromRelativeFile.filename,
                       Filename("file"))
        XCTAssertEqual(fileURLFromRelativeFile.folder,
                       Folder(url: URL(fileURLWithPath: "/tmp/relative/subdir", isDirectory: true)))
    }

    func test_FromRelativeFileURL_WithoutSubdirectory() throws {
        let relativeFileURLWithoutSubdir = URL(
            fileURLWithPath: "main.file",
            relativeTo: URL(fileURLWithPath: "/tmp/relative/"))
        let fileURLFromRelativeFileWithoutSubdir = try FileURL(from: relativeFileURLWithoutSubdir)

        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.basename,
                       Basename(filename: Filename("main"),
                               pathExtension: "file"))
        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.filename,
                       Filename("main"))
        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.folder,
                       Folder(url: URL(fileURLWithPath: "/tmp/relative", isDirectory: true)))
    }

    func testCodable_Roundtrip() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let fileURL = try FileURL(
            folder: XCTUnwrap(Folder(url: URL(filePath: "/tmp/directory/"))),
            basename: XCTUnwrap(Basename(value: "file", pathExtension: "foo"))
        )

        let jsonData = try encoder.encode(fileURL)
        XCTAssertEqual(String(data: jsonData, encoding: .utf8), #""file:\/\/\/tmp\/directory\/file.foo""#)

        let decoded = try decoder.decode(FileURL.self, from: jsonData)
        XCTAssertEqual(decoded, fileURL)
    }

    func testDecodable_StrictFileURLDecoding() throws {
        let decoder = JSONDecoder()
        decoder.userInfo[.readFileURLFromPath] = nil // or `false`, is the default
        func decoded(_ jsonString: String) throws -> FileURL {
            try decoder.decode(FileURL.self, from: jsonString.data(using: .utf8)!)
        }

        // Valid JSON requires enquoting
        XCTAssertThrowsError(try decoded(#"file://foo.x"#))

        XCTAssertThrowsError(try decoded(#""#))
        XCTAssertThrowsError(try decoded(#""""#))

        XCTAssertThrowsError(try decoded(#""file""#))
        XCTAssertThrowsError(try decoded(#"".top.secret.gpg""#))
        XCTAssertThrowsError(try decoded(#""text.txt""#))
        XCTAssertThrowsError(try decoded(#""/doc.txt""#))
        XCTAssertThrowsError(try decoded(#""relative/doc.txt""#))
        XCTAssertThrowsError(try decoded(#""/absolute/doc.txt""#))
        try XCTAssertEqual(decoded(#""file:///full/path/doc.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "/full/path/doc.txt"))))
    }

    func testDecodable_InterpretingPathsAsFileURL() throws {
        let decoder = JSONDecoder()
        decoder.userInfo[.readFileURLFromPath] = true
        func decoded(_ jsonString: String) throws -> FileURL {
            try decoder.decode(FileURL.self, from: jsonString.data(using: .utf8)!)
        }

        // Valid JSON requires enquoting
        XCTAssertThrowsError(try decoded(#"file://foo.x"#))

        XCTAssertThrowsError(try decoded(#""#))
        XCTAssertThrowsError(try decoded(#""""#))

        try XCTAssertEqual(decoded(#""file""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "file"))))
        try XCTAssertEqual(decoded(#"".top.secret.gpg""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: ".top.secret.gpg"))))
        try XCTAssertEqual(decoded(#""text.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "text.txt"))))
        try XCTAssertEqual(decoded(#""/doc.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "/doc.txt"))))
        try XCTAssertEqual(decoded(#""relative/doc.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "relative/doc.txt"))))
        try XCTAssertEqual(decoded(#""/absolute/doc.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "/absolute/doc.txt"))))
        try XCTAssertEqual(decoded(#""file:///full/path/doc.txt""#), FileURL(from: XCTUnwrap(URL(fileURLWithPath: "/full/path/doc.txt"))))
    }
}
