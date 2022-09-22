//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class FileURLTests: XCTestCase {
    let webURL = URL(string: "http://web.addres.se")!
    let folderURL = URL(fileURLWithPath: "/xyz", isDirectory: true)
    let rootURL = URL(fileURLWithPath: "/")

    func test_FromFolderAndBasename() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to", isDirectory: true)))
        let basename = Basename(filename: Filename("file"), pathExtension: "txt")
        let fileURL = FileURL(folder: folder, basename: basename)

        XCTAssertEqual(fileURL.folder, folder)
        XCTAssertEqual(fileURL.basename, basename)
        XCTAssertEqual(fileURL.filename, basename.filename)
        XCTAssertEqual(fileURL.url, URL(fileURLWithPath: "/path/to/file.txt"))
    }

    func test_FromWebURL_FailsInitialization() {
        XCTAssertNil(FileURL(from: webURL))
    }

    func test_FromFolderURL_FailsInitialization() {
        XCTAssertNil(FileURL(from: folderURL))
    }

    func test_FromRootPathURL_FailsInitialization() {
        XCTAssertNil(FileURL(from: rootURL))
    }

    func test_FromAbsoluteFileURL() throws {
        let fileURLFromFile = try XCTUnwrap(FileURL(from: URL(string: "file:///tmp/foo.bar")!))

        XCTAssertEqual(fileURLFromFile.filename,
                       Filename("foo"))
        XCTAssertEqual(fileURLFromFile.basename,
                       Basename(filename: Filename("foo"),
                                pathExtension: "bar"))
        XCTAssertEqual(fileURLFromFile.folder,
                       try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/tmp", isDirectory: true))))
    }

    func test_FromAbsoluteFileURLAtRootLevel() throws {
        let fileURL = try XCTUnwrap(FileURL(from: URL(fileURLWithPath: "/root.xyz")))

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
        let fileURLFromRelativeFile = try XCTUnwrap(FileURL(from: relativeFileURL))

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
        let fileURLFromRelativeFileWithoutSubdir = try XCTUnwrap(FileURL(from: relativeFileURLWithoutSubdir))

        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.basename,
                       Basename(filename: Filename("main"),
                               pathExtension: "file"))
        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.filename,
                       Filename("main"))
        XCTAssertEqual(fileURLFromRelativeFileWithoutSubdir.folder,
                       Folder(url: URL(fileURLWithPath: "/tmp/relative", isDirectory: true)))
    }
}
