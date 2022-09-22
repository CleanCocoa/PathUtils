//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import PathUtils

class FolderTests: XCTestCase {
    let webURL = URL(string: "https://web.addres.se")!
    let folderURL = URL(fileURLWithPath: "/xyz", isDirectory: true)
    let fileURL = URL(fileURLWithPath: "/xyz", isDirectory: false)

    func testInitializer() {
        XCTAssertNil(Folder(url: webURL))
        XCTAssertNil(Folder(url: fileURL))
        XCTAssertNotNil(Folder(url: folderURL))
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
