# ImagePalette
Swift/iOS port of Android's Palette https://developer.android.com/reference/android/support/v7/graphics/Palette.html

## Basic Usage

```swift
Palette.generateWithConfiguration(PaletteConfiguration(image: image)) {
	if let color = $0.darkMutedSwatch?.color {
		self.backgroundColor = color
	}

	if let color = $0.lightVibrantSwatch?.color {
		self.textLabel.textColor = color
	}
}
```

## License

Apache License 2.0 (inherited from the Andorid project) -- see the LICENSE file for more information.