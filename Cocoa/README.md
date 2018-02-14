# Cocoa Notes

Notes on Swift and Objective-C programming style and other Cocoa topics.


## Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Swift Lint](https://github.com/realm/SwiftLint)


## Git Etiquette

### Avoid incidental changes

Notably Xcode may make non-functional changes to `.xib` and project files which can be difficult to merge.

Additionally avoid trivial style, naming, or comment changes that are not directly related. Incidental changes add noise making code review harder.


## Managing Dependencies

[Carthage](https://github.com/Carthage/Carthage) and [Cocoapods](https://cocoapods.org) are the predominant options. One or the other is used in different projects


### Prefer Carthage

Currently Carthage is preferred because:
- easier for a new developer to get set up and install dependencies, no bundler bullshit dependency managers for dependency managers
- faster compile times, i.e. a clean build doesn't recompile dependencies
- more flexibility in project configuration
- less churn as Cocoapods updates. This is more of an issue with less vigilant developers. I suppose it's what bundler is supposed to address, but seriously.

Conversely:
- setting up and adding new dependencies is more involved

Flexibility includes configuring separate dependencies in test targets, breaking projects into multiple modules, or creating frameworks for Swift Playground Support. While configuring dependencies for multiple targets is possible with Cocoapods, it's typically done poorly, and creates a new place and new method of managing the project structure.

There is an incidental performance benefit with Carthage as dependencies are pre-compiled. With Cocoapods, a clean build will always recompile all dependencies.


### Don't Commit Dependencies

Although the general wisdom seems to be to commit dependencies, let's not.


### Swift Package Manager

In the future the [Swift Package Manager](https://swift.org/package-manager/) may supersede these options.



## Project Versioning

Cocoa projects have two version attributes:

- **Short Bundle Version String** (`CFBundleShortVersionString`), e.g. 1.4.2: should follow standard major.minor.patch version. This should be incremented accordingly with each release distribution

- **Bundle version** (`CFBundleVersion`) e.g. 23: should be incremented with each build distributed anywhere. Multiple versions may correspond to one 'version string' before it's officially released.

It's helpful to tag commits of a distributed version like `Version 1.4.2 (23)` in order to reference against crash reports.


## Project Organization

- Include the README in the Xcode project (though not in any target). Xcode formats markdown, and it's useful to both read and edit the README while working on the project.

### Flat Directory Structure

Keep the sources directory flat, and organize things into groups in the Xcode project navigator. This is less ideal for browsing the project in finder or on github, but improves Xcode's built in git tools, allowing you to reorganize files without breaking git history.


## Playgrounds for Development and Reference

Swift Playgrounds can be a great for both development and documentation. Using a playground to exercise a logic component, or display one or more states of a view can allow for quickly adjusting and verifying things during development. Often test logic can be easily translated into unit tests.

After development, a playground can document a component, demonstrating it's features interactively.

### Playgrounds in an Xcode Project

Playground can be created and dropped into the project navigator for a project. It's useful to have multiple playgrounds alongside components they document.

To run application sources in a playground, they must be included in a framework. Create a framework target called `MyAppPlaygroundSupport`, or whatever, and add sources to that target in addition to the main application. Then import the library like `@testable import MyAppPlaygroundSupport`. `@testable` allows internal declarations to be accessed. Build the 'playground support' target to run playgrounds.

An alternative is to include some sources in a framework that the app target also relies on, but this requires altering the normal procedure for adding new files, and introduces some other complexities.


## Inline Documentation


### Documentation Comments

Documentation comments are distinguished as `///` or `/** */`.

```swift
/**
 Represents a recipe loaded from the API. May belong to a `Store`. Changes to this object
 will not be persisted to the server until `save()` is called.
 */
class Recipe {
  var title: String

  /// In seconds.
  // Should we create a type alias to clarify the unit?
  var preparationTime: Double

  // ...

}
```

Hard wrap comments to 90 characters.

Use documentation vs normal comment styles to distinguish between comments useful for the consumer of an interface and notes to explain details of implementation or comment on possible alternatives.

Use multi line comments (`/** */`) for top level `class` or `struct` definitions or for
other comments that exceed three lines.

Xcode's "Counterparts" assistant editor is very useful for viewing an interface with documentation comments. Use it to verify a class is understandable.

### Don't Document the Obvious

```swift
class Recipe {
  /// The title of the recipe
  var title: String
}
```

Comments that restate what is already defined by syntax and name choices are useless noise. This likely applies to properties and method parameters.

### Do Document Exceptions, Assumptions, and Constraints

```swift
class Recipe {
  /// The sum of active and inactive time if either are defined. `nil` if neither are 
  /// defined.
  var totalTime: Double? {
    // ...
  }

  /// Expected to be positive or will be silently be converted to `nil`.
  var activeTime: Double?
}
```

- _why_ something is optional and what semantic value `nil`
- what range of values is expected
- errors that may be thrown
- invalid parameters not enforced by parameters
- side effects of methods



## Source Formatting

Prefer 2 space indentation. More importantly, be consistent within a project.


## Dividing Logical Sections

Use `// MARK: - Heading Name` to indicate logical chunks of content. For example 'actions', 'view lifecycle', or 'persistence'.

Avoid using extensions to split up segments of behavior. It's popular, but actually confusing. This makes the division between types less obvious, doesn't allow organizing stored properties, creates the illusion of decoupled logic that may in fact not be, and has subtle, unintended ramifications with subclassing and method dispatch.


## Static Data

Use `struct`s with `static` constants for things like global constants. Do not use `enum`s, as has been suggested, because it's misleading and solves a problem (instantiating an object with no purpose) that does not exist.


## Assertions & Fatal Errors

### Assertions

Use `assert()` as liberally as reasonable, to check assumptions. For example, check that UI updates occur on the main thread, or that strings match an expected format.

Catch unexpected parameters that _can_ be reasonably recovered from or a default value substituted, but practically should be handled elsewhere. This is likely a case that should also be logged remotely to be fixed.

Assertions will only fail in debug builds, so it may be reasonable to pair with actual error handling, or reasonable default behavior.

Provide a message if the condition is not independently descriptive.


### Fatal Error

`fatalError()` should *only* be used to catch *programmer errors* that are never expected to occur in production, and can not be triggered by invalid data from some external source.

A programmer error is one that only occurs from using an API in an invalid way.

There's a very good chance that any method which includes a `fatalError()` should have some documentation

Assertions and fatal may be used liberally to check assumptions you make about input, or the current state. It's better to fail quickly and explicitly, than continue to run some meaningless operation.

There are a few things to consider carefully


## Swift Lint

Swift lint is fine. Swift tends to be strict enough it's not especially necessary, but a few rules are useful. [Suggested Configuration](/.swiftlint.yml).

Some rules catch simple cases where more descriptive methods can be used e.g. [using contains](https://github.com/realm/SwiftLint/blob/master/Rules.md#contains-over-first-not-nil). And some will catch simple spacing inconsistencies.



## General Cocoa Topics

### Drawing

Custom drawing can be implemented many ways: creating a `CALayer` subclass with a custom `display()` or `drawInContext(_:)` function, using multiple `CAShapeLayer` objects, or overriding `drawRect(_:)` in a `UIView` subclass.

In general, prefer the highest level of abstraction and use a `UIView` or `NSView` subclass with a custom `drawRect(_:)` function and prefer `UIBezierPath`'s and `UIColor`'s to handle drawing rather than lower level core graphics APIs. For example:

```swift
override func drawRect(rect:CGRect) {
    let path = UIBezierPath()
    path.moveToPoint(/*...*/)
    path.addLineToPoint(/*...*/)
    UIColor.redColor().setFill()
    path.fill()
}
```

Be mindful that the `rect` parameter provided to the function is the rectangle that should be drawn and is **not** the bounds of the view.

Using path objects is more flexible than using lower level drawing functions. It allows for extracting common drawing operations into methods returning paths. Generated paths can also then be cached or inspected.
