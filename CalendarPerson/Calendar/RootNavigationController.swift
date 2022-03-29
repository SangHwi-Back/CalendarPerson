//
//  RootNavigationController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/03/23.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    private(set) var daysGenerator: DaysGenerator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.daysGenerator = DaysGenerator(baseDate: Date())
    }
}
