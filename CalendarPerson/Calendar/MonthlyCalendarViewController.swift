//
//  MonthlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class MonthlyCalendarViewController: UIViewController {

    @IBOutlet weak var monthlyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

extension MonthlyCalendarViewController: UITableViewDelegate {
    
}

extension MonthlyCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyCalendarTableViewCell", for: indexPath) as! MonthlyCalendarTableViewCell
        cell.masterVC = self
        return cell
    }
}
