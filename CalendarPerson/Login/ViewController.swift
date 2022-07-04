//
//  ViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func testButtonTouchUpInside(_ sender: UIButton) {
        performSegue(withIdentifier: "contentsSegue", sender: self)
    }
}

