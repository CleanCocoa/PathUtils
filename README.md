# PathUtils

μ-library to deal with non-empty strings, filenames, and directories.

## Usage

The base types are:

- `Basename`, e.g. "foo.txt".
- `Filename`, e.g. just "foo".
- `Folder`, which keeps a URL reference, but only to non-file URLs.
- `ContentfulString`, enabling non-empty filenames under the hood.

```swift
guard let basename = Basename("foo.txt"),
      let folder = Folder(url: URL(fileURLWithPath: "/path/to/success/"))
else { exit }

let path: String = folder + basename
```

## Installation

### Using Swift Package Manager

```swift
.package(url: "https://github.com/CleanCocoa/PathUtils", from: "1.0.0")
```

## License

[MIT](./LICENSE)
