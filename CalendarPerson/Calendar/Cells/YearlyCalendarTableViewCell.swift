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
    var monthMetadata: [Int: MonthMetadata]?
    
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
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearlyCalendarCollectionViewCell", for: indexPath)
        
        guard let metadata = monthMetadata?[indexPath.row + (indexYearInRow * 3) + 1] else {
            return UICollectionViewCell()
        }
        
        if let commonCalendar = cell.subviews.first(where: {v in v is CommonCalendarView}) as? CommonCalendarView {
            
            commonCalendar.monthMetadata = metadata
            
        } else if let commonCalendar = Bundle.main.loadNibNamed("CommonCalendarView", owner: nil)?.first as? CommonCalendarView {
            
            commonCalendar.frame = cell.bounds
            commonCalendar.monthMetadata = metadata
            cell.addSubview(commonCalendar)
        }

        return cell
    }
}
