//
//  CalendarInfoTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/07/05.
//

import UIKit

class CalendarInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var layout: UICollectionViewFlowLayout!
    
    var yearMetadata: YearMetadata? {
        didSet {
            if let year = self.yearMetadata?.components.year {
                self.yearLabel.text = "\(year)"
            }
            
            self.calendarCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 16
        let width = (calendarCollectionView.frame.width / CGFloat(3)) - layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionViewHeightConstraint.constant = (width * 4) + (layout.minimumLineSpacing * 3)
        calendarCollectionView.collectionViewLayout = layout
        calendarCollectionView.dataSource = self
    }
}

extension CalendarInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        yearMetadata?.monthsMetadata?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearlyCalendarCollectionViewCell", for: indexPath)
        
        guard let metadata = yearMetadata?.monthsMetadata?[indexPath.row+1] else {
            return cell
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
