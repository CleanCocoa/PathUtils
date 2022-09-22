//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class FileURLTests: XCTestCase {
    let webURL = URL(string: "http://web.addres.se")!
    let fileURL = URL(string: "file:///tmp/foo.bar")!
    let folderURL = URL(fileURLWithPath: "/xyz", isDirectory: true)
    let relativeFileURL = URL(
        fileURLWithPath: "subdir/file.txt",
        relativeTo: URL(fileURLWithPath: "/tmp/relative/"))
    let rootURL = URL(fileURLWithPath: "/")

    func testInit_FromFolderAndBasename() throws {
        let folder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/path/to", isDirectory: true)))
        let basename = Basename(filename: Filename("file"), pathExtension: "txt")
        let fileURL = FileURL(folder: folder, basename: basename)

        XCTAssertEqual(fileURL.folder, folder)
        XCTAssertEqual(fileURL.basename, basename)
        XCTAssertEqual(fileURL.filename, basename.filename)
        XCTAssertEqual(fileURL.url, URL(fileURLWithPath: "/path/to/file.txt"))
    }

    func testInit_FromURL() {
        XCTAssertNil(FileURL(from: webURL))
        XCTAssertNil(FileURL(from: folderURL))
        XCTAssertNil(FileURL(from: rootURL))
        XCTAssertNotNil(FileURL(from: fileURL))
        XCTAssertNotNil(FileURL(from: relativeFileURL))
    }

    func testFilename() {
        XCTAssertEqual(FileURL(from: fileURL)?.filename,
                       Filename("foo"))
        XCTAssertEqual(FileURL(from: relativeFileURL)?.filename,
                       Filename("file"))
    }

    func testBasename() {
        XCTAssertEqual(FileURL(from: fileURL)?.basename,
                       Basename(filename: Filename("foo"),
                                pathExtension: "bar"))
        XCTAssertEqual(FileURL(from: relativeFileURL)?.basename,
                       Basename(filename: Filename("file"),
                               pathExtension: "txt"))
    }

    func testFolder_FilesInDirectories() {
        XCTAssertEqual(FileURL(from: fileURL)?.folder?.path,
                       "/tmp")
        XCTAssertEqual(FileURL(from: relativeFileURL)?.folder?.path,
                       "/tmp/relative/subdir")

        let relativeFileURLWithoutSubdir = URL(
            fileURLWithPath: "file.txt",
            relativeTo: URL(fileURLWithPath: "/tmp/relative/"))
        XCTAssertEqual(FileURL(from: relativeFileURLWithoutSubdir)?.folder?.path,
                       "/tmp/relative")
    }

    func testFolder_RootLevelFiles() throws {
        let rootFolder = try XCTUnwrap(Folder(url: URL(fileURLWithPath: "/", isDirectory: true)))

        let rootFile = URL(fileURLWithPath: "/root.xyz")
        XCTAssertEqual(FileURL(from: rootFile)?.folder,
                       rootFolder)
    }
}
