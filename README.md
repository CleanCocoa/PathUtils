# PathUtils

μ-library to deal with non-empty strings, filenames, and directories.

## Usage

The base types protect important invariants and are as follows:

- `ContentfulString` cannot be constructed from an empty string.
- `Filename`, e.g. just "foo". The filename is never an empty string.
- `Basename`, e.g. "foo.txt". The path extension is optional, but a valid filename is always present.
- `Folder` keeps a URL reference, but only to local directory URLs.
- `FileURL` only accepts local `file:` URLs, but rejects directories.

`FileURL` is the true star of the show: It combines `Folder` + `Basename` to represent local file URLs,
so access to these never fails. Once you have a `FileURL`, you get checks for non-directory, local `file:` URLs
for free. There's always going to be a basename for convenient access.

Construct file URLs from components, e.g. to create a destination URL for a new file in an existing folder:

```swift
guard let basename = Basename("foo.txt"),
      let folder = Folder(url: URL(fileURLWithPath: "/path/to/success/"))
else { exit }

let fileURL: FileURL = basename.fileURL(relativeTo: folder)
```

Filter URLs from user input for local filesystem references:

```swift
let url: URL = ...

guard let fileURL = FileURL(from: url) else { exit }

print("You selected", fileURL.basename, "in", fileURL.folder)
```

Construct file URLs from existing primitives by concatenation through custom operators:

```swift
// Custom operators!
let path: String = folder + basename
let fileURL: FileURL = folder + basename
```

## Installation

### Using Swift Package Manager

```swift
.package(url: "https://github.com/CleanCocoa/PathUtils", from: "0.3.2")
```

## License

[MIT](./LICENSE)
