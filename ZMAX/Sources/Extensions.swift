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
	
	public func newAccessibilityObserver(runLoopModes: [RunLoop.Mode] = [RunLoop.Mode.default]) throws -> ZMAXObserver
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
	
	public func getAttribute<T>(for name: NSAccessibility.Attribute) throws -> T
	{
		let objectPtr = UnsafeMutablePointer<AnyObject?>.allocate(capacity: 1)
		defer { objectPtr.deallocate() }
		
		try AXUIElementCopyAttributeValue(self, (name.rawValue as CFString), objectPtr).throwIfNotSuccess()
		let object = objectPtr.pointee
		return (object as! T)
	}
    public func getAttributeOptional<T>(for name: NSAccessibility.Attribute) throws -> T?
    {
        let objectPtr = UnsafeMutablePointer<AnyObject?>.allocate(capacity: 1)
        defer { objectPtr.deallocate() }
        
        try AXUIElementCopyAttributeValue(self, (name.rawValue as CFString), objectPtr).throwIfNotSuccess()
        let object = objectPtr.pointee
        return (object as? T)
    }
	public func getAttribute<T>(for name: NSAccessibility.Attribute, axType: AXValueType) throws -> T
	{
		let axValue: AXValue = try getAttribute(for: name)
		var value: T?; do {
			let valuePtr = UnsafeMutablePointer<T?>.allocate(capacity: 1)
			AXValueGetValue(axValue, axType, valuePtr)
			value = valuePtr.pointee
			valuePtr.deallocate()
		}
		return value!
	}
	public func getAttribute(for name: NSAccessibility.Attribute) throws -> Int
	{
		return (try getAttribute(for: name) as NSNumber).intValue
	}
	public func getAttribute(for name: NSAccessibility.Attribute) throws -> CGPoint
	{
		return try getAttribute(for: name, axType: .cgPoint) as CGPoint
	}
	public func getAttribute(for name: NSAccessibility.Attribute) throws -> CGSize
	{
		return try getAttribute(for: name, axType: .cgSize) as CGSize
	}
	public func getAttribute(for name: NSAccessibility.Attribute) throws -> CGRect
	{
		return try getAttribute(for: name, axType: .cgRect) as CGRect
	}
	public func getAttribute(for name: NSAccessibility.Attribute) throws -> CFRange
	{
		return try getAttribute(for: name, axType: .cfRange) as CFRange
	}
	
	public func setAttribute(_ value: Any, for name: NSAccessibility.Attribute) throws
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
	
	public func getMultipleAttributes<T>(for names: [NSAccessibility.Attribute], options: AXCopyMultipleAttributeOptions = []) throws -> T
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate() }
		
		try AXUIElementCopyMultipleAttributeValues(self, (names as CFArray), options, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! T)
	}
	
	public func getAttributeCount(for name: NSAccessibility.Attribute) throws -> Int
	{
		var count: CFIndex = 0
		try AXUIElementGetAttributeValueCount(self, (name.rawValue as CFString), &count).throwIfNotSuccess()
		return count
	}
	public func getAttributeValues<T>(for name: NSAccessibility.Attribute, in range: CountableRange<Int>) throws -> T
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate() }
		
		try AXUIElementCopyAttributeValues(self, (name.rawValue as CFString), range.min()!, range.max()!, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! T)
	}
	
	public func getAttributeNames() throws -> [NSAccessibility.Attribute]
	{
		let arrayPtr = UnsafeMutablePointer<CFArray?>.allocate(capacity: 1)
		defer { arrayPtr.deallocate() }
		
		try AXUIElementCopyAttributeNames(self, arrayPtr).throwIfNotSuccess()
		let array = arrayPtr.pointee
		return (array as! [NSAccessibility.Attribute])
	}
	
	public func isAttributeSettable(for name: NSAccessibility.Attribute) throws -> Bool
	{
		let boolPtr = UnsafeMutablePointer<DarwinBoolean>.allocate(capacity: 1)
		defer { boolPtr.deallocate() }
		
		try AXUIElementIsAttributeSettable(self, (name.rawValue as CFString), boolPtr).throwIfNotSuccess()
		let bool = boolPtr.pointee.boolValue
		return bool
	}
	
	public func performAction(_ action: ZMAXActionName) throws
	{
		try AXUIElementPerformAction(self, action.rawValue as CFString).throwIfNotSuccess()
	}
}

extension AXUIElement {
    /// Gets the element at the specified coordinates.
    ///
    /// This can only be called on applications and the system-wide element.
    public func elementAtPosition(appUIElement: AXUIElement, _ x: Float, _ y: Float) throws -> AXUIElement? {
        var element: AXUIElement?
        let error = AXUIElementCopyElementAtPosition(self, x, y, &element)
        if error == .noValue {
            return nil
        }
        guard error == .success else {
            throw error
        }
        return element
    }
    
    public static func systemwide(at position: NSPoint) -> AXUIElement? {
        let swElement = AXUIElementCreateSystemWide()
        do {
            if let swElementAtPos = try swElement.elementAtPosition(appUIElement: swElement, Float(position.x), Float(position.y)) {
                return swElementAtPos
            }
        } catch {
            print("\(error.self): \(error.localizedDescription)")
            // FIXME: os_log or throw
        }
        return nil
    }
    
    /// Returns the process ID of the application that the element is a part of.
    ///
    /// Throws only if the element is invalid (`Errors.InvalidUIElement`).
    open func pid() throws -> pid_t {
        var pid: pid_t = -1
        let error = AXUIElementGetPid(self, &pid)
        guard error == .success else {
            throw error
        }
        return pid
    }
}

// for conversion AXValue (wrapper) <> wrapped value
// from: https://github.com/keith/ModMove/blob/main/ModMove/AXValue%2BHelper.swift
extension AXValue {
    func toValue<T>() -> T? {
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        let success = AXValueGetValue(self, AXValueGetType(self), pointer)
        return success ? pointer.pointee : nil
    }

    static func from<T>(value: T, type: AXValueType) -> AXValue? {
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        pointer.pointee = value
        return AXValueCreate(type, pointer)
    }
}
