//
//  String.swift
//  HabitTracker
//
//  Created by David Sadler on 9/8/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension String {
    
    func endsInAnSs() -> Bool {
        if self.endsInAnS() {
            let onePastLastIndex = self.endIndex
            let secondToLastIndex = self.index(onePastLastIndex, offsetBy: -2)
            if self[secondToLastIndex] == Character("s") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func endsInAnEs() -> Bool {
        if self.endsInAnS() {
            let onePastLastIndex = self.endIndex
            let secondToLastIndex = self.index(onePastLastIndex, offsetBy: -2)
            let secondToLastChar = self[secondToLastIndex]
            if secondToLastChar == Character("e") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func endsInAnSsEs() -> Bool {
        if self.endsInAnEs() {
            let onePastLastIndex = self.endIndex
            let thirdToLastIndex = self.index(onePastLastIndex, offsetBy: -3)
            let nextCheckString = String(self[self.startIndex...thirdToLastIndex])
            if nextCheckString.endsInAnSs() {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func endsInAnS() -> Bool {
        guard let endChar = self.last else { return false }
        if endChar == Character("s") {
            return true
        }
        return false
    }
    
    func pluralize() -> String {
        var str = self
        if str.endsInAnSs() {
            str.append("es")
        } else {
            str.append("s")
        }
        return str
    }
    
    func dePluralize() -> String {
        let beginingIndex = self.startIndex
        let endIndex = self.endIndex
        if self.endsInAnSsEs() {
            // form a string from the begining to the thrid last char
            let thridToTheLastCharIndex = self.index(endIndex, offsetBy: -3)
            let desiredSlice = self[beginingIndex...thridToTheLastCharIndex]
            return String(desiredSlice)
        } else {
            // form a string from the begining to the second to last char
            let secondToTheLastCharIndex = self.index(endIndex, offsetBy: -2)
            let desiredSlice = self[beginingIndex...secondToTheLastCharIndex]
            return String(desiredSlice)
        }
    }
    
}
