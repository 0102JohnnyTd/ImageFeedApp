//
//  Person.swift
//  ImageFeedApp
//
//  Created by Johnny Toda on 2023/01/10.
//

import Foundation


// Personの更新パターンを管理するenum
enum PersonUpdate {
    case delete(Int)
    case insert(Person, Int)
    case move(Int, Int)
    case reload(Int)
}

// PersonCellに表示するPersonのモデル
struct Person: CustomStringConvertible {
    var name: String?
    var imgName: String?
    var lastUpdate = Date()

    init(name: String, day: Int, month: Int, year: Int) {
        self.name = name
        self.imgName = name.lowercased()

        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year

        if let date = Calendar.current.date(from: components) {
            lastUpdate = date
        }
    }

    var isUpdated: Bool? {
        didSet {
            lastUpdate = Date()
        }
    }

    var description: String {
        if let name = self.name {
            return "<\(type(of: self)): name = \(name)>"
        } else {
            return "<\(type(of: self))>"
        }
    }
}
