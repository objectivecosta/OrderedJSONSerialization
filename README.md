# OrderedJSONSerialization

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Why?

For some reason, neither Apple, nor any other JSON serialization library for Swift supports ordered JSON. This fixes it.

Even though the JSON RFC specifies that the order is not important for JSON documents, in some cases, ordering is desired. With Swift's native .sortedKeys WritingOption, this is partially supported, but only on the top-level of the document. Given Dictionary's unsorted nature of storing items, when using JSON documents as queries on backend services, this randomness prevents  caching on a CDN that uses the body as the key. For this case, and others, there's OrderedJSONSerialization.

## Installation

OrderedJSONSerialization is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OrderedJSONSerialization'
```

## Author

Rafael Costa, rafael@rafaelcosta.me

## License

OrderedJSONSerialization is available under the MIT license. See the LICENSE file for more info.
