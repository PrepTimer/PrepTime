# PrepTimer
The codebase for the PrepTime app refresh. The app is currently being rewritten with the Flutter framework. The target date for launch will be January of 2021.

## Cider CI
We will be using the [cider](https://pub.dev/packages/cider) command-line utility to automate package maintenance. This tool assumes that the changelog:
- is called `CHANGELOG.md`
- is located in the root
- strictly follows the `Keep a Changelog` v1.0.0 format
- uses baseic markdown

#### Step 1: Update the Changelog
To use this tool, you should install the tool via the directions linked above. Then, to log a new line to the chaneglog, simply type your command using one of {`added`, `changed`, `depreciated`, `removed`, `fixed`, `security`}.

```
    cider log change 'New turbo engine installed'
    cider log add 'Support for rocket fuel and kerosene'
    cider log fix 'No more wheels falling off'
```

#### Step 2: Bump the Version
To increase the version of the package, simply use one of the version keywords from {`breaking`, `major`, `minor`, `patch`, `build`}. Remember that the semantic version specifies a version as `major.minor.patch+build`. You can also retain the build with the `-b` flag.
```
    cider bump patch
```

#### Step 3: Release the Changes
To take all the unreleased changes and insert them into a new release with the version from pubspec.yaml:
```
    cider release
```