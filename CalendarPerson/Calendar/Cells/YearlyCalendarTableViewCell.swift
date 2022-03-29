//
//  YearlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class YearlyCalendarTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    var monthMetadata: [MonthMetadata]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        let width = (self.frame.width/3)-10
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: width, height: width * 4)
        
        calendarCollectionView.collectionViewLayout = layout
        calendarCollectionView.dataSource = self
        calendarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = monthMetadata?.count ?? 0
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: YearlyCalendarCollectionViewCell.self), for: indexPath) as? YearlyCalendarCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.metadata = monthMetadata?[indexPath.row]
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
