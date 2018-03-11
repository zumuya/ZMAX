/*
 Extensions.swift

 Created by zumuya on 2018/03/11.

 Copyright 2018 zumuya

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 and associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial
 portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
 APARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Cocoa

extension NSRunningApplication
{
	public var accessibilityElement: AXUIElement
	{
		return AXUIElement.application(processIdentifier: processIdentifier)
	}
	
	public func newAccessibilityObserver(runLoopModes: [RunLoopMode] = [.defaultRunLoopMode]) throws -> ZMAXObserver
	{
		return try ZMAXObserver(processIdentifier: processIdentifier, runLoopModes: runLoopModes)
	}
}

extension AXUIElement
{
	public class var systemwide: AXUIElement
	{
		return AXUIElementCreateSystemWide()
	}
	public class func application(processIdentifier: pid_t) -> AXUIElement
	{
		return AXUIElementCreateApplication(processIdentifier)
	}
	
	public func getAttribute<T>(for name: NSAccessibilityAttributeName) throws -> T
	{
		let objectPtr = UnsafeMutablePointer<AnyObject?>.allocate(capacity: 1)
		defer { objectPtr.deallocate(capacity: 1) }
		
		try AXUIElementCopyAttributeValue(self, (name.rawValue as CFString), objectPtr).throwIfNotSuccess()
		let object = objectPtr.pointee
		return (object as! T)
	}
	public func getAttribute<T>(for name: NSAccessibilityAttributeName, axType: AXValueType) throws -> T
	{
		let axValue: AXValue = try getAttribute(for: name)
		var value: T?; do {
			let valuePtr = UnsafeMutablePointer<T?>.allocate(capacity: 1)
			AXValueGetValue(axValue, axType, valuePtr)
			value = valuePtr.pointee
			valuePtr.deallocate(capacity: 1)
		}
		return value!
	}
	public func getAttribute(for name: NSAccessibilityAttributeName) throws -> Int
	{
		return (try getAttribute(for: name) as NSNumber).intValue
	}
	public func getAttribute(for name: NSAccessibilityAttributeName) throws -> CGPoint
	{
		return try getAttribute(for: name, axType: .cgPoint) as CGPoint
	}
	public func getAttribute(for name: NSAccessibilityAttributeName) throws -> CGSize
	{
		return try getAttribute(for: name, axType: .cgSize) as CGSize
	}
	public func getAttribute(for name: NSAccessibilityAttributeName) throws -> CGRect
	{
		return try getAttribute(for: name, axType: .cgRect) as CGRect
	}
	public func getAttribute(for name: NSAccessibilityAttributeName) throws -> CFRange
	{
		return try getAttribute(for: name, axType: .cfRange) as CFRange
	}
	
	public func setAttribute(_ value: Any, for name: NSAccessibilityAttributeName) throws
	{
		let objectValue: AnyObject
		if var point = value as? CGPoint {
			objectValue = AXValueCreate(.cgPoint, &point)!
		} else if var size = value as? CGSize {
			objectValue = AXValueCreate(.cgPoint, &size)!
		} else {
			objectValue = value as AnyObject
		}
		try AXUIElementSetAttributeValue(self, (name.rawValue as CFString), objectValue).throwIfNotSuccess()
	}
	
	public func getMultipleAttributes<T>(for names: [NSAccessibilityAttributeName], options: AXCopyMultipleAttributeOptions = []) throws -> T
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate(capacity: 1) }
		
		try AXUIElementCopyMultipleAttributeValues(self, (names as CFArray), options, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! T)
	}
	
	public func getAttributeCount(for name: NSAccessibilityAttributeName) throws -> Int
	{
		var count: CFIndex = 0
		try AXUIElementGetAttributeValueCount(self, (name.rawValue as CFString), &count).throwIfNotSuccess()
		return count
	}
	public func getAttributeValues<T>(for name: NSAccessibilityAttributeName, in range: CountableRange<Int>) throws -> T
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate(capacity: 1) }
		
		try AXUIElementCopyAttributeValues(self, (name.rawValue as CFString), range.min()!, range.max()!, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! T)
	}
	
	public func getAttributeNames() throws -> [NSAccessibilityAttributeName]
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate(capacity: 1) }
		
		try AXUIElementCopyAttributeNames(self, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! [NSAccessibilityAttributeName])
	}
	
	public func isAttributeSettable(for name: NSAccessibilityAttributeName) throws -> Bool
	{
		let boolPtr = UnsafeMutablePointer<DarwinBoolean>.allocate(capacity: 1)
		defer { boolPtr.deallocate(capacity: 1) }
		
		try AXUIElementIsAttributeSettable(self, (name.rawValue as CFString), boolPtr).throwIfNotSuccess()
		let bool = boolPtr.pointee.boolValue
		return bool
	}
	
	public func performAction(_ action: ZMAXActionName) throws
	{
		try AXUIElementPerformAction(self, action.rawValue as CFString).throwIfNotSuccess()
	}
}
