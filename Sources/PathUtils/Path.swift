//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

@inlinable @inline(__always)
public func + (folder: Folder, filename: Filename) -> String {
    return filename.url(relativeTo: folder, pathExtension: "").absoluteURL.path
}

@inlinable @inline(__always)
public func + (folder: Folder, filename: Filename) -> FileURL {
    return folder.fileURL(filename: filename, pathExtension: "")
}

@inlinable @inline(__always)
public func + (folder: Folder, basename: Basename) -> String {
    return basename.url(relativeTo: folder).absoluteURL.path
}

@inlinable @inline(__always)
public func + (folder: Folder, basename: Basename) -> FileURL {
    return folder.fileURL(basename: basename)
}
