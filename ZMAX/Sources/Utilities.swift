//
//  Utilities.swift
//  ZMAX
//
//  Created by Felix on 23.11.22.
//  Copyright © 2022 zumuya. All rights reserved.
//

import Cocoa

@discardableResult
public func checkIsProcessTrusted(prompt: Bool = false) -> Bool {
    let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
    let opts = [promptKey: prompt] as CFDictionary
    return AXIsProcessTrustedWithOptions(opts)
}
