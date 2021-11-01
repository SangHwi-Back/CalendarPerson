//
//  CommonCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/28.
//

import UIKit

enum CalendarDataError: Error {
    case metadataGeneration
    case baseDateError
}

struct Day {
    let date: Date
    let number: String
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
}

class CommonCalendarViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var startDate: Date!
    var calendar = Calendar.current
    var dateFormatter = DateFormatter()
    
    var calendarSize: CGSize!
    var showHeaderView: Bool = false
    var showFooterView: Bool = false
    var selectCellEnable: Bool = false
    
    var daysInMonth: [Day]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = calendarSize
        dateFormatter.dateFormat = "MMM"
        headerLabel.text = dateFormatter.string(from: startDate)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        layout.itemSize = CGSize(width: calendarSize.width / 9, height: calendarSize.width / 8)
        
        collectionView.collectionViewLayout = layout
        
        if startDate == nil {
            dismiss(animated: false, completion: nil)
        }
        
        daysInMonth = generateDayInMonth(for: startDate)
        collectionView.reloadData()
    }
    
    func getMonthInfo(for baseDate: Date) throws -> MonthMetadata {
        
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekDay
        )
    }
    
    func generateDayInMonth(for baseDate: Date) -> [Day] {
        
        guard let metadata = try? getMonthInfo(for: baseDate) else {
            fatalError("CommonCalendarViewController baseDate Error : \(baseDate)")
        }
        
        dateFormatter.dateFormat = "d"
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? (day - offsetInInitialRow) : -(offsetInInitialRow - day)
            
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth
            )
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    func generateStartOfNextMonth(
      using firstDayOfDisplayedMonth: Date
      ) -> [Day] {
      guard
        let lastDayInMonth = calendar.date(
          byAdding: DateComponents(month: 1, day: -1),
          to: firstDayOfDisplayedMonth)
        else {
          return []
      }

      let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
      guard additionalDays > 0 else {
        return []
      }

      let days: [Day] = (1...additionalDays)
        .map {
          generateDay(
          offsetBy: $0,
          for: lastDayInMonth,
          isWithinDisplayedMonth: false)
        }

      return days
    }
    
    func generateDay(
      offsetBy dayOffset: Int,
      for baseDate: Date,
      isWithinDisplayedMonth: Bool
    ) -> Day {
      let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate

      return Day(
        date: date,
        number: dateFormatter.string(from: date),
        isSelected: calendar.isDate(date, inSameDayAs: startDate),
        isWithinDisplayedMonth: isWithinDisplayedMonth
      )
    }
}

extension CommonCalendarViewController: UICollectionViewDelegate {
    
}

extension CommonCalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCalendarCollectionViewCell.reuseIdentifier, for: indexPath) as! CommonCalendarCollectionViewCell
        let date = daysInMonth[indexPath.row]
        cell.dateLabel.text = date.isWithinDisplayedMonth ? date.number : ""
        
        return cell
    }
}

class CommonCalendarCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier = String(describing: CommonCalendarCollectionViewCell.self)
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
