//  Copyright © 2022 Christian Tietze. All rights reserved. Distributed under the MIT License.

public func + (folder: Folder, filename: Filename) -> String {
    return folder
      .url
      .appendingPathComponent(filename.string)
      .absoluteString
}
