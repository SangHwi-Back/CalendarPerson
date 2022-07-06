//
//  YearlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

protocol YearlyTableViewSegueDelegate {
    func goDetail(_ date: Date)
}

class YearlyCalendarViewController: UIViewController {

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var yearlyTableView: UITableView!
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    private var yearGenerator: DaysOfYearInCalendar!
    
    private var dateFormatter = DateFormatter()
    private var yearMetadata = [YearMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let year = Calendar.current.dateComponents([.year], from: Date()).year!
        
        dateFormatter.dateFormat = "y"
        yearGenerator = DaysOfYearInCalendar(current: Calendar.current, formatString: "d", startYear: year - 8)
        
        do {
            for _ in 0..<14 {
                yearMetadata.append(try yearGenerator.getNextYearMetadata())
            }
        } catch {
            print(error)
        }
        
        if yearlyTableView.numberOfSections > 4 {
            yearlyTableView.scrollToRow(
                at: IndexPath(row: 0, section: 7),
                at: .top,
                animated: false
            )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MonthlyCalendarViewController {
            dest.modalTransitionStyle = .flipHorizontal
            dest.baseDate = yearGenerator.baseDate
        }
    }
    
    @IBAction func settingButtonTouchUpInside(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "SettingViewController", sender: self)
    }
}

extension YearlyCalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yearMetadata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CalendarInfoTableViewCell.reuseIdentifier,
            for: indexPath) as? CalendarInfoTableViewCell
        else {
            return UITableViewCell()
        }
        
        let metadata = yearMetadata[indexPath.section]
        cell.yearMetadata = metadata
        cell.didSelectRowHandler = {
            self.goDetail(Date())
        }
        
        return cell
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
