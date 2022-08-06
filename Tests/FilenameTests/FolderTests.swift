//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import Filename

class FolderTests: XCTestCase {
    func testInit_FolderURL_Succeeds() {
        let folderUrl = URL(fileURLWithPath: "/xyz", isDirectory: true)
        XCTAssertNotNil(Folder(url: folderUrl))
    }

    func testInit_FileURL_Fails() {
        let fileUrl = URL(fileURLWithPath: "/xyz", isDirectory: false)
        XCTAssertNil(Folder(url: fileUrl))
    }

    func testEquatability() {
        XCTAssertEqual(Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!,
                       Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!)
        XCTAssertEqual(Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!,
                       Folder(url: URL(fileURLWithPath: "folder/", isDirectory: true, relativeTo: URL(fileURLWithPath: "/path/to/")))!)
        XCTAssertEqual(Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!,
                       Folder(url: URL(fileURLWithPath: "../../folder/", isDirectory: true, relativeTo: URL(fileURLWithPath: "/path/to/nested/folder/inside")))!)

        XCTAssertNotEqual(Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!,
                          Folder(url: URL(fileURLWithPath: "/path/to/other/"))!)
        XCTAssertNotEqual(Folder(url: URL(fileURLWithPath: "/path/to/folder/"))!,
                          Folder(url: URL(fileURLWithPath: "/path/to/"))!)
    }
}
