//
//  YearlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

protocol YearlyTableViewDateFetchDelegate {
    func sendCommonCalendars(_ calendars: [UIViewController], year: String)
}

protocol YearlyTableViewSegueDelegate {
    func goDetail(_ date: Date)
}

class YearlyCalendarViewController: UIViewController {

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var yearlyTableView: UITableView!
    
    var currentDateDisplayed: Date = Date()
    var calendar = Calendar(identifier: .gregorian)
    var dateFormatter = DateFormatter()
    var isFirst = true
    
    // TableView Models
    var dateVCs = [String: [UIViewController]]()
    var dates = [String: [Date]]()
    var datesIndex = [IndexPath: String]()
    
    var lastYear: String {
        return String(self.dates.keys.min(by: {Int($0)! > Int($1)!}) ?? "")
    }
    var firstYear: String {
        return String(self.dates.keys.max(by: {Int($0)! > Int($1)!}) ?? "")
    }
    lazy var valueOffset = { [self] () -> Int in
        if yearlyTableView.contentOffset.y > oldOffset.y {
            return 1
        } else if yearlyTableView.contentOffset.y < oldOffset.y {
            return -1
        }
        
        return 0
    }
    lazy var valueIndexPath = { [self] (index: Int) -> Int in
        if oldIndexPathRow < index {
            return 1
        } else if oldIndexPathRow > index {
            return -1
        }
        
        return 0
    }
    
    var oldIndexPathRow: Int = 0
    var oldOffset = CGPoint()
    var valueApplyingCurrentDate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "y"
        
        let currentYear = calendar.dateComponents([.year], from: currentDateDisplayed).year
        let dateComponents = DateComponents(calendar: calendar, year: currentYear, month: 2, day: 0)
        currentDateDisplayed = dateComponents.date!
        
        for i in 0...10 {
            if let date = calendar.date(byAdding: .year, value: -5+i, to: currentDateDisplayed) {
                appendYearMetaDates(in: date)
            }
        }
        
//        if let date = calendar.date(byAdding: .year, value: -1, to: currentDateDisplayed) {
//            appendYearMetaDates(in: date)
//        }
//        appendYearMetaDates(in: currentDateDisplayed)
//        if let date = calendar.date(byAdding: .year, value: 1, to: currentDateDisplayed) {
//            appendYearMetaDates(in: date, willBeReload: true)
//        }
        
        yearlyTableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let date = sender as? Date,
           let dest = segue.destination as? MonthlyCalendarViewController
        {
            dest.baseDate = date
        }
    }
    
    func appendYearMetaDates(in date: Date, willBeReload: Bool = false) {
        
        guard let year = calendar.dateComponents([.year], from: date).year else { return }
        
        if Array(dates.keys).firstIndex(of: String(year)) != nil {
            return
        }
        
        dates[String(year)] = [Date]()
        let firstDate = calendar.date(from: DateComponents(calendar: calendar, year: year, month: 2, day: 0))!
//        components.month = 13
//        components.day = 0
//        let lastDate = calendar.date(from: components)!
        
//        DispatchQueue.global(qos: .userInitiated).async {
            for i in (0 ..< 12) {
                if let date = calendar.date(byAdding: .month, value: i, to: firstDate) {
                    self.dates[String(year)]!.append(date)
                }
            }
//        }
        
        if willBeReload {
            yearlyTableView.reloadData()
        }
    }
}

extension YearlyCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension YearlyCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        defer {
            DispatchQueue.main.async { [self] in
                valueApplyingCurrentDate = valueOffset()
                oldOffset = tableView.contentOffset
            }
        }
        
        let year = dateFormatter.string(from: currentDateDisplayed)
        
        if indexPath.row.isMultiple(of: 2) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: YearlyCalendarHeaderTableViewCell.reuseIdentifier, for: indexPath) as! YearlyCalendarHeaderTableViewCell
            cell.yearLabel.text = year
            
            let valueNeedToAdd = year == firstYear ? -1 : (year == lastYear ? 1 : 0)
            
            if valueNeedToAdd != 0 {
                
                guard let dateApplyValue = calendar.date(byAdding: .year, value: valueNeedToAdd, to: currentDateDisplayed) else {
                    return cell
                }
                
                if Array(dates.keys).firstIndex(of: dateFormatter.string(from: dateApplyValue)) == nil {
                    appendYearMetaDates(in: dateApplyValue)
                    if let secondDate = calendar.date(byAdding: .year, value: valueNeedToAdd, to: dateApplyValue) {
                        appendYearMetaDates(in: secondDate, willBeReload: true)
                    }
                }
            }
            
            if valueApplyingCurrentDate < 0 {
                if let date = calendar.date(byAdding: .year, value: valueApplyingCurrentDate, to: currentDateDisplayed) {
                    print("head", valueApplyingCurrentDate, currentDateDisplayed, date)
                    currentDateDisplayed = date
                }
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: YearlyCalendarTableViewCell.reuseIdentifier, for: indexPath) as! YearlyCalendarTableViewCell
            
            cell.segueDelegate = self
            cell.dataFetchDelegate = self
            cell.datesInARow = dates[year]
            cell.year = year
            
            if let VCs = dateVCs[year] {
                cell.datesinCells = VCs
                cell.alreadyInstalled = true
            }
            
            if valueApplyingCurrentDate > 0 {
                if let date = calendar.date(byAdding: .year, value: valueApplyingCurrentDate, to: currentDateDisplayed) {
                    print("foot", valueApplyingCurrentDate, currentDateDisplayed, date)
                    currentDateDisplayed = date
                }
            }
            
            return cell
        }
    }
}

extension YearlyCalendarViewController: YearlyTableViewSegueDelegate {
    func goDetail(_ date: Date) {
        self.performSegue(
            withIdentifier: String(describing: MonthlyCalendarViewController.self),
            sender: date
        )
    }
}

extension YearlyCalendarViewController: YearlyTableViewDateFetchDelegate {
    func sendCommonCalendars(_ calendars: [UIViewController], year: String) {
        self.dateVCs[year] = calendars
    }
}
