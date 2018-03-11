/*
 Constants.swift

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

public struct ZMAXActionName: RawRepresentable
{
	public let rawValue: String
	public init(rawValue: String)
	{
		self.rawValue = rawValue
	}
	
	public static let press = ZMAXActionName(rawValue: kAXPressAction)
	public static let increment = ZMAXActionName(rawValue: kAXIncrementAction)
	public static let decrement = ZMAXActionName(rawValue: kAXDecrementAction)
	public static let confirm = ZMAXActionName(rawValue: kAXConfirmAction)
	public static let cancel = ZMAXActionName(rawValue: kAXCancelAction)
	public static let showAlternateUi = ZMAXActionName(rawValue: kAXShowAlternateUIAction)
	public static let showDefaultUi = ZMAXActionName(rawValue: kAXShowDefaultUIAction)
	public static let raise = ZMAXActionName(rawValue: kAXRaiseAction)
	public static let showMenu = ZMAXActionName(rawValue: kAXShowMenuAction)
	public static let pick = ZMAXActionName(rawValue: kAXPickAction)
}
public struct ZMAXNotificationName: RawRepresentable
{
	public let rawValue: String
	public init(rawValue: String)
	{
		self.rawValue = rawValue
	}
	
	public static let mainWindowChanged = ZMAXNotificationName(rawValue: kAXMainWindowChangedNotification)
	public static let focusedWindowChanged = ZMAXNotificationName(rawValue: kAXFocusedWindowChangedNotification)
	public static let focusedUiElementChanged = ZMAXNotificationName(rawValue: kAXFocusedUIElementChangedNotification)
	public static let applicationActivated = ZMAXNotificationName(rawValue: kAXApplicationActivatedNotification)
	public static let applicationDeactivated = ZMAXNotificationName(rawValue: kAXApplicationDeactivatedNotification)
	public static let applicationHidden = ZMAXNotificationName(rawValue: kAXApplicationHiddenNotification)
	public static let applicationShown = ZMAXNotificationName(rawValue: kAXApplicationShownNotification)
	public static let windowCreated = ZMAXNotificationName(rawValue: kAXWindowCreatedNotification)
	public static let windowMoved = ZMAXNotificationName(rawValue: kAXWindowMovedNotification)
	public static let windowResized = ZMAXNotificationName(rawValue: kAXWindowResizedNotification)
	public static let windowMiniaturized = ZMAXNotificationName(rawValue: kAXWindowMiniaturizedNotification)
	public static let windowDeminiaturized = ZMAXNotificationName(rawValue: kAXWindowDeminiaturizedNotification)
	public static let drawerCreated = ZMAXNotificationName(rawValue: kAXDrawerCreatedNotification)
	public static let sheetCreated = ZMAXNotificationName(rawValue: kAXSheetCreatedNotification)
	public static let helpTagCreated = ZMAXNotificationName(rawValue: kAXHelpTagCreatedNotification)
	public static let valueChanged = ZMAXNotificationName(rawValue: kAXValueChangedNotification)
	public static let uiElementDestroyed = ZMAXNotificationName(rawValue: kAXUIElementDestroyedNotification)
	public static let elementBusyChanged = ZMAXNotificationName(rawValue: kAXElementBusyChangedNotification)
	public static let menuOpened = ZMAXNotificationName(rawValue: kAXMenuOpenedNotification)
	public static let menuClosed = ZMAXNotificationName(rawValue: kAXMenuClosedNotification)
	public static let menuItemSelected = ZMAXNotificationName(rawValue: kAXMenuItemSelectedNotification)
	public static let rowCountChanged = ZMAXNotificationName(rawValue: kAXRowCountChangedNotification)
	public static let rowExpanded = ZMAXNotificationName(rawValue: kAXRowExpandedNotification)
	public static let rowCollapsed = ZMAXNotificationName(rawValue: kAXRowCollapsedNotification)
	public static let selectedCellsChanged = ZMAXNotificationName(rawValue: kAXSelectedCellsChangedNotification)
	public static let unitsChanged = ZMAXNotificationName(rawValue: kAXUnitsChangedNotification)
	public static let selectedChildrenMoved = ZMAXNotificationName(rawValue: kAXSelectedChildrenMovedNotification)
	public static let selectedChildrenChanged = ZMAXNotificationName(rawValue: kAXSelectedChildrenChangedNotification)
	public static let resized = ZMAXNotificationName(rawValue: kAXResizedNotification)
	public static let moved = ZMAXNotificationName(rawValue: kAXMovedNotification)
	public static let created = ZMAXNotificationName(rawValue: kAXCreatedNotification)
	public static let selectedRowsChanged = ZMAXNotificationName(rawValue: kAXSelectedRowsChangedNotification)
	public static let selectedColumnsChanged = ZMAXNotificationName(rawValue: kAXSelectedColumnsChangedNotification)
	public static let selectedTextChanged = ZMAXNotificationName(rawValue: kAXSelectedTextChangedNotification)
	public static let titleChanged = ZMAXNotificationName(rawValue: kAXTitleChangedNotification)
	public static let layoutChanged = ZMAXNotificationName(rawValue: kAXLayoutChangedNotification)
	public static let announcementRequested = ZMAXNotificationName(rawValue: kAXAnnouncementRequestedNotification)
}

extension AXError: LocalizedError
{
	func throwIfNotSuccess() throws
	{
		if (self != .success) {
			throw self
		}
	}
	func throwIfNotSuccess(_ altError: @autoclosure ()->Error) throws
	{
		if (self != .success) {
			throw altError()
		}
	}
	
	public static var localizedDescriptionHandlers: [((AXError) -> String?)] = []
	public static var recoverySuggestionHandlers: [((AXError) -> String?)] = []
	
	public var recoverySuggestion: String?
	{
		for recoverySuggestionHandler in AXError.recoverySuggestionHandlers {
			if let recoverySuggestion = recoverySuggestionHandler(self) {
				return recoverySuggestion
			}
		}
		return nil
	}
	
	public var errorDescription: String?
	{
		for localizedDescriptionHandler in AXError.localizedDescriptionHandlers {
			if let localizedDescription = localizedDescriptionHandler(self) {
				return localizedDescription
			}
		}
		switch self {
		case .success:
			return "success"
		case .failure:
			return "Accessibility: Failure"
		case .illegalArgument:
			return "Accessibility: Illegal argument"
		case .invalidUIElement:
			return "Accessibility: Invalid UI element"
		case .invalidUIElementObserver:
			return "Accessibility: Invalid UI element observer"
		case .cannotComplete:
			return "Cannot complete."
		case .attributeUnsupported:
			return "Accessibility Attribute is not supported."
		case .actionUnsupported:
			return "Accessibility action is not supported."
		case .notificationUnsupported:
			return "Accessibility notification is not supported."
		case .notImplemented:
			return "Accessibility is not implemented."
		case .notificationAlreadyRegistered:
			return "Accessibility notification has already been registered."
		case .notificationNotRegistered:
			return "Accessibility notification is not registered."
		case .apiDisabled:
			return "Accessibility API is disabled."
		case .noValue:
			return "Accessibility API returned no value."
		case .parameterizedAttributeUnsupported:
			return "Accessibility parameterized attribute is not supported"
		case .notEnoughPrecision:
			return "Accessibility: Not enough precision"
		}
	}
}
