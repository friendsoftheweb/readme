# Setup

The project is targeted at Swift 4. Build, run, and distribute with [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12).

### Dependencies

#### Cocoapods

Dependencies are installed with [Cocoapods](http://cocoapods.org).

To install Cocoapods:

```shell
sudo gem install cocoapods
```

Cocoapods requires Ruby, and might be complicated if you're using something like `rbenv` to manage multiple versions of Ruby.

Install dependencies by running this in the project directory:

```shell
pod install
```

#### Carthage

Dependencies are installed through [Carthage](https://github.com/Carthage/Carthage).

[Install Carthage](https://github.com/Carthage/Carthage#installing-carthage) with Homebrew
or with the installer package. Then run in the project directory:

```shell
$ carthage bootstrap --platform macOS
```


### Testing

Select the `MyProject` scheme and press `cmd` + `u`.

## Playground Support

Playgrounds are used to develop and document components.

[More Details](MyProjectPlaygroundSupport)

### Running

Run the project from the `.xcworkspace` file, use the `MyProject` scheme.


## Project Organization

## Build Configurations

## Persistence / Data Storage Strategy

### Core Data

## Swift and Objective-C

Older source files are written in Objective-C, but Swift is favored as much as possible. New sources should be written in swift.
