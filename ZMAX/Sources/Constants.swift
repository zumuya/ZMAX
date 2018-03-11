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

public struct ZAXActionName: RawRepresentable
{
	public let rawValue: String
	public init(rawValue: String)
	{
		self.rawValue = rawValue
	}
	
	public static let press = ZAXActionName(rawValue: kAXPressAction)
	public static let increment = ZAXActionName(rawValue: kAXIncrementAction)
	public static let decrement = ZAXActionName(rawValue: kAXDecrementAction)
	public static let confirm = ZAXActionName(rawValue: kAXConfirmAction)
	public static let cancel = ZAXActionName(rawValue: kAXCancelAction)
	public static let showAlternateUi = ZAXActionName(rawValue: kAXShowAlternateUIAction)
	public static let showDefaultUi = ZAXActionName(rawValue: kAXShowDefaultUIAction)
	public static let raise = ZAXActionName(rawValue: kAXRaiseAction)
	public static let showMenu = ZAXActionName(rawValue: kAXShowMenuAction)
	public static let pick = ZAXActionName(rawValue: kAXPickAction)
}
public struct ZAXNotificationName: RawRepresentable
{
	public let rawValue: String
	public init(rawValue: String)
	{
		self.rawValue = rawValue
	}
	
	public static let mainWindowChanged = ZAXNotificationName(rawValue: kAXMainWindowChangedNotification)
	public static let focusedWindowChanged = ZAXNotificationName(rawValue: kAXFocusedWindowChangedNotification)
	public static let focusedUiElementChanged = ZAXNotificationName(rawValue: kAXFocusedUIElementChangedNotification)
	public static let applicationActivated = ZAXNotificationName(rawValue: kAXApplicationActivatedNotification)
	public static let applicationDeactivated = ZAXNotificationName(rawValue: kAXApplicationDeactivatedNotification)
	public static let applicationHidden = ZAXNotificationName(rawValue: kAXApplicationHiddenNotification)
	public static let applicationShown = ZAXNotificationName(rawValue: kAXApplicationShownNotification)
	public static let windowCreated = ZAXNotificationName(rawValue: kAXWindowCreatedNotification)
	public static let windowMoved = ZAXNotificationName(rawValue: kAXWindowMovedNotification)
	public static let windowResized = ZAXNotificationName(rawValue: kAXWindowResizedNotification)
	public static let windowMiniaturized = ZAXNotificationName(rawValue: kAXWindowMiniaturizedNotification)
	public static let windowDeminiaturized = ZAXNotificationName(rawValue: kAXWindowDeminiaturizedNotification)
	public static let drawerCreated = ZAXNotificationName(rawValue: kAXDrawerCreatedNotification)
	public static let sheetCreated = ZAXNotificationName(rawValue: kAXSheetCreatedNotification)
	public static let helpTagCreated = ZAXNotificationName(rawValue: kAXHelpTagCreatedNotification)
	public static let valueChanged = ZAXNotificationName(rawValue: kAXValueChangedNotification)
	public static let uiElementDestroyed = ZAXNotificationName(rawValue: kAXUIElementDestroyedNotification)
	public static let elementBusyChanged = ZAXNotificationName(rawValue: kAXElementBusyChangedNotification)
	public static let menuOpened = ZAXNotificationName(rawValue: kAXMenuOpenedNotification)
	public static let menuClosed = ZAXNotificationName(rawValue: kAXMenuClosedNotification)
	public static let menuItemSelected = ZAXNotificationName(rawValue: kAXMenuItemSelectedNotification)
	public static let rowCountChanged = ZAXNotificationName(rawValue: kAXRowCountChangedNotification)
	public static let rowExpanded = ZAXNotificationName(rawValue: kAXRowExpandedNotification)
	public static let rowCollapsed = ZAXNotificationName(rawValue: kAXRowCollapsedNotification)
	public static let selectedCellsChanged = ZAXNotificationName(rawValue: kAXSelectedCellsChangedNotification)
	public static let unitsChanged = ZAXNotificationName(rawValue: kAXUnitsChangedNotification)
	public static let selectedChildrenMoved = ZAXNotificationName(rawValue: kAXSelectedChildrenMovedNotification)
	public static let selectedChildrenChanged = ZAXNotificationName(rawValue: kAXSelectedChildrenChangedNotification)
	public static let resized = ZAXNotificationName(rawValue: kAXResizedNotification)
	public static let moved = ZAXNotificationName(rawValue: kAXMovedNotification)
	public static let created = ZAXNotificationName(rawValue: kAXCreatedNotification)
	public static let selectedRowsChanged = ZAXNotificationName(rawValue: kAXSelectedRowsChangedNotification)
	public static let selectedColumnsChanged = ZAXNotificationName(rawValue: kAXSelectedColumnsChangedNotification)
	public static let selectedTextChanged = ZAXNotificationName(rawValue: kAXSelectedTextChangedNotification)
	public static let titleChanged = ZAXNotificationName(rawValue: kAXTitleChangedNotification)
	public static let layoutChanged = ZAXNotificationName(rawValue: kAXLayoutChangedNotification)
	public static let announcementRequested = ZAXNotificationName(rawValue: kAXAnnouncementRequestedNotification)
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
	
	public static var customLocalizedDescriptionHandlers: [((AXError) -> String?)] = []
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
		for customLocalizedDescriptionHandler in AXError.customLocalizedDescriptionHandlers {
			if let localizedDescription = customLocalizedDescriptionHandler(self) {
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
