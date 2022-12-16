//
//  HideMenuIcon.swift
//  HomeworkBox
//
//  Created by Nate on 12/16/22.
//

import SwiftUI

class Stack {
    static let shared = Stack()
    private init() {}

    var visible: Bool = true

    func updateValue(newValue: Bool) {
        self.visible = newValue
    }
}
