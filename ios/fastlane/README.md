fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```



### ios renew_certs

```sh
[bundle exec] fastlane ios renew_certs
```



### ios certs

```sh
[bundle exec] fastlane ios certs
```



### ios asc_key

```sh
[bundle exec] fastlane ios asc_key
```



### ios fetch_and_increment_build_number

```sh
[bundle exec] fastlane ios fetch_and_increment_build_number
```

Bump build number based on most recent TestFlight build number

### ios build_for_testflight

```sh
[bundle exec] fastlane ios build_for_testflight
```



### ios build_for_alpha_testers

```sh
[bundle exec] fastlane ios build_for_alpha_testers
```



### ios build_for_beta_testers

```sh
[bundle exec] fastlane ios build_for_beta_testers
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
