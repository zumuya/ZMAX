# ZMAX

ZMAX is a framework that bridges AX (Accessibility) APIs to Swift.

## Usages

### Getting an application element

```swift
let runningApps = NSWorkspace.shared.runningApplications
if let safariApp = runningApps.first(where: { $0.bundleIdentifier == "com.apple.Safari" }) {
	let safari = safariApp.accessibilityElement
}
```

### Getting an attribute

```swift
let windows = try safari.getAttribute(for: .windows) as [AXUIElement]
```

### Performing an action

```swift
try minimizeButton.performAction(.press)
```

### Example 1: Pressing minimize buttons in Safari

```swift
let runningApps = NSWorkspace.shared.runningApplications
if let safariApp = runningApps.first(where: { $0.bundleIdentifier == "com.apple.Safari" }) {
	let safari = safariApp.accessibilityElement
	
	let windows = try safari.getAttribute(for: .windows) as [AXUIElement]
	for window in windows {
		let title = try window.getAttribute(for: .title) as String
		let minimizeButton = try window.getAttribute(for: .minimizeButton) as AXUIElement
		try minimizeButton.performAction(.press)
	}
}
```

### Example2: Observing focused UI element changes in Safari

```swift
let runningApps = NSWorkspace.shared.runningApplications
if let safariApp = runningApps.first(where: { $0.bundleIdentifier == "com.apple.Safari" }) {
	let safari = safariApp.accessibilityElement
	
	let observer = try safariApp.newAccessibilityObserver()
	try observer.observe(element: safari, notification: .focusedUiElementChanged) { element, changes in
		if let role = try? element.getAttribute(for: .role) as String {
			print("focused element changed to \(role).")
		}
	}
}

self.safariObserver = observer //keep it!
```
