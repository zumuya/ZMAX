/*
 Observer.swift

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

public final class ZMAXObserver
{
	let axObserver: AXObserver
	var removeRunLoopHandlers: [()->Void] = []
	
	convenience init(application: NSRunningApplication, runLoopModes: [RunLoopMode] = [.defaultRunLoopMode]) throws
	{
		try self.init(processIdentifier: application.processIdentifier, runLoopModes: runLoopModes)
	}
	
	public init(processIdentifier: pid_t, runLoopModes: [RunLoopMode] = [.defaultRunLoopMode]) throws
	{
		let observerPtr = UnsafeMutablePointer<AXObserver?>.allocate(capacity: 1)
		defer { observerPtr.deallocate(capacity: 1) }
		try AXObserverCreateWithInfoCallback(processIdentifier, { (observer, element, notification, /*nullable*/changesCf, userInfoPtr) in
			if let userInfoPtr = userInfoPtr {
				let userInfo = Unmanaged<_ObservingUserInfo>.fromOpaque(userInfoPtr).takeUnretainedValue()
				let changes = (changesCf as? [String : Any] ?? [:])
				userInfo.observer?.handleNotification(element: element, userInfo: userInfo, changes: changes)
			}
		}, observerPtr).throwIfNotSuccess()
		axObserver = observerPtr.pointee!
		
		let runLoop = RunLoop.current.getCFRunLoop()
		let runLoopSource = AXObserverGetRunLoopSource(axObserver)
		for runLoopMode in runLoopModes {
			let cfRunLoopMode = CFRunLoopMode(rawValue: (runLoopMode.rawValue as CFString))
			CFRunLoopAddSource(runLoop, runLoopSource, cfRunLoopMode);
			removeRunLoopHandlers.append {
				CFRunLoopRemoveSource(runLoop, runLoopSource, cfRunLoopMode)
			}
		}
	}
	deinit
	{
		invalidate()
		for removeRunLoopHandler in removeRunLoopHandlers {
			removeRunLoopHandler()
		}
	}
	func invalidate()
	{
		let handleInfos_ = handleInfos
		for handleInfo in handleInfos_ {
			try? removeNotification(userInfo: handleInfo)
		}
	}
	func handleNotification(element: AXUIElement, userInfo: _ObservingUserInfo, changes: [String: Any])
	{
		userInfo.handler(element, changes)
	}
	func removeNotification(userInfo: _ObservingUserInfo) throws
	{
		if let index = handleInfos.index(of: userInfo) {
			try AXObserverRemoveNotification(axObserver, userInfo.element, (userInfo.notification.rawValue as CFString)).throwIfNotSuccess()
			Unmanaged.passUnretained(userInfo).release()
			handleInfos.remove(at: index)
		}
	}
	
	@objc final class _ObservingUserInfo: NSObject
	{
		weak var observer: ZMAXObserver!
		let element: AXUIElement
		let notification: ZMAXNotificationName
		let handler: (AXUIElement, [String: Any]) -> Void
		
		public init(observer: ZMAXObserver, element: AXUIElement, notification: ZMAXNotificationName, handler: @escaping (_ element: AXUIElement, _ changes: [String: Any]) -> Void)
		{
			self.observer = observer
			self.element = element
			self.notification = notification
			self.handler = handler
			super.init()
		}
	}
	
	public func observe(element: AXUIElement, notification: ZMAXNotificationName, handler: @escaping (_ element: AXUIElement, _ changes: [String: Any]) -> Void) throws
	{
		let userInfo = _ObservingUserInfo(observer: self, element: element, notification: notification, handler: handler)
		try AXObserverAddNotification(axObserver, element, (notification.rawValue as CFString), Unmanaged.passRetained(userInfo).toOpaque()).throwIfNotSuccess()
		handleInfos.append(userInfo)
	}
	
	var handleInfos: [_ObservingUserInfo] = []
}
