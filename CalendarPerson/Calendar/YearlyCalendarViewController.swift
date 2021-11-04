//
//  YearlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

protocol YearlyTableViewDateFetchDelegate {
    func fetchNewDates(_ isNextYear: Bool) -> [Date]?
}

protocol YearlyTableViewSegueDelegate {
    func goDetail(_ date: Date)
}

class YearlyCalendarViewController: UIViewController {

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var yearlyTableView: UITableView!
    
    var dates: [Date] = [Date]() {
        didSet {
            self.yearlyTableView.reloadData()
        }
    }
    var currentDateDisplayed: Date = Date()
    var calendar = Calendar(identifier: .gregorian)
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "y"
        var dateComponent = calendar.dateComponents([.year], from: currentDateDisplayed)
        dateComponent.day = 1
        let startDateBeforeDay = calendar.date(from: dateComponent)
        
        if let date = startDateBeforeDay {
            for i in (0 ..< 12) {
                if let date = calendar.date(byAdding: .month, value: i, to: date) {
                    dates.append(date)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let date = sender as? Date,
           let dest = segue.destination as? MonthlyCalendarViewController
        {
            dest.baseDate = date
        }
    }
}

extension YearlyCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row.isMultiple(of: 2) {
            return 50
        } else {
            return yearlyTableView.frame.height - 30
        }
    }
}

extension YearlyCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row.isMultiple(of: 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: YearlyCalendarHeaderTableViewCell.reuseIdentifier, for: indexPath) as! YearlyCalendarHeaderTableViewCell
            cell.yearLabel.text = dateFormatter.string(from: self.currentDateDisplayed)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: YearlyCalendarTableViewCell.reuseIdentifier, for: indexPath) as! YearlyCalendarTableViewCell
            cell.delegate = self
            cell.dates = dates
            return cell
        }
    }
}

//extension YearlyCalendarViewController: YearlyTableViewDateFetchDelegate {
//    func fetchNewDates(_ isNextYear: Bool) -> [Date]? {
//
//        guard let dateCalculated = calendar.date(
//            byAdding: .month,
//            value: (isNextYear ? 1 : -1),
//            to: currentDateDisplayed)
//        else {
//            fatalError("date that calculated for tableview in year are error!!!!!")
////            return nil
//        }
//
//        self.currentDateDisplayed = dateCalculated
//
//
//    }
//}

extension YearlyCalendarViewController: YearlyTableViewSegueDelegate {
    func goDetail(_ date: Date) {
        self.performSegue(
            withIdentifier: String(describing: MonthlyCalendarViewController.self),
            sender: date
        )
    }
}
