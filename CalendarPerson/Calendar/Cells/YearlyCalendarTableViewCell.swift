//
//  YearlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class YearlyCalendarTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var monthsInYearCollectionView: UICollectionView!
    var indexYearInRow: Int = 0
    var monthMetadata: [MonthMetadata]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 16
        let width = (monthsInYearCollectionView.frame.width / CGFloat(3)) - layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        
        monthsInYearCollectionView.collectionViewLayout = layout
        monthsInYearCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let result = monthMetadata?.count ?? 0
//        return result
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: YearlyCalendarCollectionViewCell.self), for: indexPath)
        
        if let commonCalendar = cell.subviews.first(where: {v in v is CommonCalendarView}) as? CommonCalendarView {
            commonCalendar.monthMetadata = monthMetadata![indexPath.row]
        } else {
            if let commonCalendar = Bundle.main.loadNibNamed("CommonCalendarView", owner: nil)?.first as? CommonCalendarView {
                commonCalendar.frame = cell.bounds
                commonCalendar.monthMetadata = monthMetadata![indexPath.row + (indexYearInRow * 3)]
                cell.addSubview(commonCalendar)
            } else {
                print("What??")
            }
        }

        return cell
    }
}

class YearlyCalendarCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthInYearCollectionView: UICollectionView!
    
    var metadata: MonthMetadata?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
//        let maxNumber = metadata?.numberOfDays ?? 30
        let width = (self.frame.width/7)-1
//        let height = width * CGFloat((maxNumber / 7) + (maxNumber % 7 > 0 ? 1 : 0))
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: width, height: width)
        
        monthInYearCollectionView.collectionViewLayout = layout
        monthInYearCollectionView.dataSource = self
        monthInYearCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = metadata?.numberOfDays ?? 0
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewDayCell", for: indexPath) as? CalendarCollectionViewDayCell else {
            return UICollectionViewCell()
        }
        
        let model = metadata?.dayMetadata?[indexPath.row]
        cell.dayNumberLabel.text = model?.day
        
        return cell
    }
}

class CalendarCollectionViewDayCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
