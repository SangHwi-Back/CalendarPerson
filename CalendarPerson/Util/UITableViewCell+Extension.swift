//
//  UITableViewCell+Extension.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/07/05.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
