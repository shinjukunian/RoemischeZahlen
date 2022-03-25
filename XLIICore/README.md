# XLIICore

The XLIICore package provides parsing / formatting of 'exotic' numerals and number systems.

## Installation
Via the Swift Package Manager.
Add 

```swift
.package(url: "https://github.com/shinjukunian/XLII.git", .branch("main"))
```

to `package.swift`.

## Use

### Formatting
The `Output` enum encapsulates the desired output format. Conversion can be achieved via a `NumericalConversionHolder`

```swift
let number=42
let outputs=Output.builtin
for output in outputs {
	let holder=NumeralConversionHolder(input: number, output: output, originalText: String(number))
 	print("\(holder.input) is \(holder.formattedOutput) as \(holder.output.description)")
 }
//42 is XLII as Roman
//42 is 𒐏𒐖 as Babylonian Cuneiform
//and so on
```

For some numeral types, output formatting can be customized:

```swift
let number=2022
var options=NumeralConversionHolder.ConversionContext()
options.uppercaseCyrillic=false
let holder=NumeralConversionHolder(input: number, output: output, originalText: String(number, context: options)
//҂вк҃в
options.uppercaseCyrillic=true
//҂ВК҃В
```
This results in ҂вк҃в (lower case) and ҂ВК҃В (uppercase). The addition of the dicaritic titlo can be customized as well. 

### Parsing
Parsing can be accomplished through an instance of `ExotischerZahlenFormatter`

```swift
let number=҂вк҃в
let parsed=ExotischerZahlenFormatter().macheZahl(aus: number) //an instance of `ExotischerZahlenFormatter.NumericalOutput`
let locale=parsed.locale //cyrillic
let value=parsed.value //2022 as integer
```

## Licence
MIT
