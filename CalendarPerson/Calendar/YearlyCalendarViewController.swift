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
    
    private var dateFormatter = DateFormatter()
    private var yearGenerator = DaysOfYearInCalendar(current: Calendar.current, formatString: "d")!
    private var yearMetadata = [YearMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "y"
        
        do {
            yearMetadata.append(try yearGenerator.getPreviousYearMetadata())
            yearMetadata.append(try yearGenerator.getYearMetadata())
            yearMetadata.append(try yearGenerator.getNextYearMetadata())
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MonthlyCalendarViewController {
            dest.baseDate = yearGenerator.baseDate
        }
    }
}

extension YearlyCalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        yearMetadata.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let metadata = yearMetadata[section]
        return dateFormatter.string(from: metadata.date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: YearlyCalendarTableViewCell.self), for: indexPath) as? YearlyCalendarTableViewCell else {
            return UITableViewCell()
        }
        
        let metadata = yearMetadata[indexPath.row]
        cell.monthMetadata = metadata.monthsMetadata
        
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
