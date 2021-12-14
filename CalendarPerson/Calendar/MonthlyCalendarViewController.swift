//
//  MonthlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class MonthlyCalendarViewController: UIViewController {

    @IBOutlet weak var monthlyTableView: UITableView!
    
    var baseDate: Date?
    var daysGenerator: DaysGenerator!
    
    var days: [Day]? {
        didSet {
            monthlyTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysGenerator = (UIApplication.shared.delegate as! AppDelegate).daysGenerator
        
        if let baseDate = baseDate {
            daysGenerator.changeDate(with: baseDate)
            var dateComponent = daysGenerator.calendar.dateComponents([.month], from: baseDate)
            dateComponent.day = 1
            
            if let date = daysGenerator.calendar.date(from: dateComponent) {
                self.days = daysGenerator.generateDayInMonth(for: date)
            }
        }
    }
}

extension MonthlyCalendarViewController: UITableViewDelegate {
    
}

extension MonthlyCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (days?.count ?? 0) / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyCalendarTableViewCell.reuseIdentifier, for: indexPath) as! MonthlyCalendarTableViewCell
        cell.masterVC = self
        cell.days = days
        return cell
    }
}
