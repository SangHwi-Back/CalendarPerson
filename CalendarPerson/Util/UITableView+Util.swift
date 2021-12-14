//
//  UITableView+Util.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/10.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToIndexPath(_ indexPath: IndexPath) {
        self.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}
