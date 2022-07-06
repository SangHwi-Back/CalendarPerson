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
    
    var yearMetadata: YearMetadata? {
        didSet {
            if let year = self.yearMetadata?.components.year {
                self.yearLabel.text = "\(year)"
            }
            
            self.calendarCollectionView.reloadData()
        }
    }
    
    var didSelectRowHandler: (() -> Void)?
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = getLayout()
        calendarCollectionView.collectionViewLayout = layout
        
        collectionViewHeightConstraint.constant = (layout.itemSize.width * 4) + (layout.minimumLineSpacing * 3)
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    
    private func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 16
        let width = (calendarCollectionView.frame.width / CGFloat(3)) - layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        return layout
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
        
        var commonCalendar = cell.subviews.first(where: { $0 is CommonCalendarView }) as? CommonCalendarView
        
        if commonCalendar == nil, let commonCalendarCreated = Bundle.main.loadNibNamed("CommonCalendarView", owner: nil)?.first as? CommonCalendarView {
            
            cell.addSubview(commonCalendarCreated)
            commonCalendarCreated.frame = cell.bounds
            commonCalendar = commonCalendarCreated
        }
        
        commonCalendar?.monthMetadata = metadata
        
        return cell
    }
}

extension CalendarInfoTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectRowHandler?()
    }
}
