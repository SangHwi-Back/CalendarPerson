//
//  YearlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class YearlyCalendarViewController: UIViewController {

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var yearlyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension YearlyCalendarViewController: UITableViewDelegate {
}

extension YearlyCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearlyCalendarTableViewCell", for: indexPath) as! YearlyCalendarTableViewCell
        cell.masterVC = self
        return cell
    }
}
