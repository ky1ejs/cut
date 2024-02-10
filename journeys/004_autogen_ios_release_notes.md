## Ideal features
1. Change log is uploaded with iOS build for current release (prev version number to current commit)
2. List changes in current version and previous version on iOS

## 1. Changelog uploaded to App Store Connect
This isn't working right now, but it seems one of these things is the cause:
* https://github.com/fastlane/fastlane/issues/16129#issuecomment-757020428
* https://github.com/fastlane/fastlane/issues/16129#issuecomment-1136411727
* https://github.com/fastlane/fastlane/issues/16129#issuecomment-1136792292

I'll revist this another time, probably when I share the app to external testers.


## 2. Changelog on iOS

__this section is a wip__

In order to do this we need to:
1. create a file on disk for the iOS build to include
2. cache previous version changelog, otherwise we'll need to build our entire history of changelogs
