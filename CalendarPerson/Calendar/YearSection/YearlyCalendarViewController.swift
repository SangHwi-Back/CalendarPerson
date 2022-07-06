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
    private var yearMetadata = [YearMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let year = Calendar.current.dateComponents([.year], from: Date()).year!
        
        yearGenerator = DaysOfYearInCalendar(current: Calendar.current, formatString: "d", startYear: year-4)
        
        do {
            for _ in 0..<9 {
                yearMetadata.append(try yearGenerator.getNextYearMetadata())
            }
        } catch {
            print(error)
        }
        
        yearlyTableView.dataSource = self
        yearlyTableView.delegate = self
        yearlyTableView.scrollToRow(
            at: IndexPath(row: 5, section: 0),
            at: .middle,
            animated: false
        )
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
        
        let metadata = yearMetadata[indexPath.row]
        cell.yearMetadata = metadata
        cell.indexPath = indexPath
        cell.didSelectRowHandler = {
            self.goDetail(Date())
        }
        
        return cell
    }
}

extension YearlyCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard yearMetadata.isEmpty == false, (indexPath.row == 0 || indexPath.row == yearMetadata.count - 1) else {
            return
        }
        
        let isFirstRow = indexPath.row == 0
        let dateStandard = isFirstRow ? yearMetadata.first?.date : yearMetadata.last?.date
        
        if let date = dateStandard {
            
            yearGenerator.setDate(base: date)
            
            do {
                if isFirstRow {
                    yearMetadata.insert(try yearGenerator.getPreviousYearMetadata(), at: 0)
                    yearMetadata.removeLast()
                } else {
                    yearMetadata.append(try yearGenerator.getNextYearMetadata())
                    yearMetadata.removeFirst()
                }
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                tableView.performBatchUpdates {
                    tableView.deleteRows(at: [IndexPath(row: isFirstRow ? tableView.numberOfRows(inSection: 0)-1 : 0, section: 0)], with: .none)
                    tableView.insertRows(at: [IndexPath(row: isFirstRow ? 0 : tableView.numberOfRows(inSection: 0)-1, section: 0)], with: .none)
                }
            }
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
