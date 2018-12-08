![Harvey logo](Design/logo.png)

[![CircleCI](https://circleci.com/gh/Moya/Harvey/tree/master.svg?style=svg)](https://circleci.com/gh/Moya/Harvey/tree/master)

Harvey is a SPM-first network response stubbing library written completely in Swift. Main goals:
- [x] Stubbing based on given request properties (url/method etc.)
- [x] Removing stubs
- [x] Compatible with SPM
- [ ] Compatible with Carthage
- [ ] Record/save/use recorded stubs
- [ ] Moya plugin to easily handle Harvey
- [x] Compatibility with CocoaPods

You can check out more about the project direction in the [vision document](VISION.md).

# Development
Right now the development process is quite unfortunate due to the bug with Quick (see [Quick#751](https://github.com/Quick/Quick/issues/751) and [SPM#1406](https://github.com/apple/swift-package-manager/pull/1406)):

1. Install [spm_utils](https://github.com/sunshinejr/spm_utils)
1. Clone Harvey and enter Harvey's root directory.
1. Run `swift package generate-xcodeproj` to generate a project.
1. Run `spm_utils quick` to fix the bug with Quick.
1. If you want to test Swift 4 version of Harvey, run `spm_utils swift 4`.

Now just enter the project and it _should_ build. Otherwise please fill an issue.

# Contributions
Contributions are welcome, but keep in mind that for now the main goal is a 
stable and working version, so development might progress _fast_.

This project is open source under the MIT license, which means you have 
full access to the source code and can modify it to fit your own needs.

This project also subscribes to the [Moya Contributors Guidelines](https://github.com/Moya/contributors) which TLDR: means we give out push access easily and often.

And also this project subscribes to the [Contributor Code of Conduct](http://contributor-covenant.org/version/1/4/), based on the [Contributor Covenant](http://contributor-covenant.org) version 1.4.0. The maintainers take the code of conduct seriously. 

# License
MIT.