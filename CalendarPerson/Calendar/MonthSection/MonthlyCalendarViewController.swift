//
//  MonthlyCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class MonthlyCalendarViewController: UIViewController {

    @IBOutlet weak var monthlyTableView: UITableView!
    
    private var generator: DaysOfMonthInCalendar!
    var startDate: Date?
    var metadata = [MonthMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let date = startDate, let dateFourMonthEalrier = Calendar.current.date(byAdding: .month, value: -3, to: date) else {
            return
        }
        
        generator = DaysOfMonthInCalendar(current: Calendar.current, formatString: "MMMM", date: dateFourMonthEalrier)
        
        do {
            for _ in 0..<6 {
                metadata.append(try generator.getNextMonthMetadata())
            }
        } catch {
            print(error)
        }
        
        monthlyTableView.delegate = self
        monthlyTableView.dataSource = self
        monthlyTableView.rowHeight = monthlyTableView.frame.width
        monthlyTableView.scrollToRow(
            at: IndexPath(row: 2, section: 0),
            at: .middle,
            animated: false
        )
    }
}

extension MonthlyCalendarViewController: UITableViewDelegate { }

extension MonthlyCalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metadata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MonthlyCalendarTableViewCell.reuseIdentifier, for: indexPath) as! MonthlyCalendarTableViewCell
        cell.masterVC = self
        
        var commonCalendar = cell.subviews.first(where: { $0 is CommonCalendarView }) as? CommonCalendarView
        
        if commonCalendar == nil, let commonCalendarCreated = Bundle.main.loadNibNamed("CommonCalendarView", owner: nil)?.first as? CommonCalendarView {
            
            cell.addSubview(commonCalendarCreated)
            commonCalendarCreated.frame = cell.bounds
            commonCalendar = commonCalendarCreated
        }
        
        commonCalendar?.monthMetadata = metadata[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard metadata.isEmpty == false, (indexPath.row == 0 || indexPath.row == metadata.count - 1) else {
            return
        }
        
        let isFirstRow = indexPath.row == 0
        let dateStandard = isFirstRow ? metadata.first?.date : metadata.last?.date
        
        if let date = dateStandard {
            
            generator.setDate(base: date)
            
            do {
                if isFirstRow {
                    metadata.insert(try generator.getPreviousMonthMetadata(), at: 0)
                    metadata.removeLast()
                } else {
                    metadata.append(try generator.getNextMonthMetadata())
                    metadata.removeFirst()
                }
            } catch {
                print(error)
            }
            
            let lastRowNumber = tableView.numberOfRows(inSection: 0)-1
            
            DispatchQueue.main.async {
                tableView.performBatchUpdates {
                    tableView.deleteRows(at: [IndexPath(row: isFirstRow ? lastRowNumber : 0, section: 0),], with: .none)
                    tableView.insertRows(at: [IndexPath(row: isFirstRow ? 0 : lastRowNumber, section: 0),], with: .none)
                }
            }
        }
    }
}
