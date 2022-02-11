//
//  Utils.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-25.
//
import Foundation

struct Utils {
    static func cuurentTimeStamp() -> Int {
        return Int(round(NSDate().timeIntervalSince1970))
    }
}
