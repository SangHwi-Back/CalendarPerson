//
//  DailyScheduleViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class DailyScheduleViewController: UIViewController {

    @IBOutlet weak var dailyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DailyScheduleViewController: UITableViewDelegate {
    
}

extension DailyScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyScheduleTableViewCell", for: indexPath) as! DailyScheduleTableViewCell
        cell.masterVC = self
        return cell
    }
}
