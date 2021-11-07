//
//  YearlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class YearlyCalendarTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: YearlyCalendarTableViewCell.self)
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewConstraintHeight: NSLayoutConstraint!
    
    var delegate: YearlyTableViewSegueDelegate?
    var dates: [Date]? {
        didSet {
            calendarCollectionView.reloadData()
            let height = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height
            if height > calendarCollectionViewConstraintHeight.constant {
                calendarCollectionViewConstraintHeight.constant = height
                superview?.setNeedsLayout()
                superview?.layoutIfNeeded()
            }
        }
    } // previousMonthFirstDay, currentMonthFirstDay, nextMonthFirstDay
    
    private lazy var viewWidth: CGFloat = self.calendarCollectionView.frame.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(
            width: (viewWidth / 3) - (layout.minimumInteritemSpacing * 2),
            height: (viewWidth / 3) - (layout.minimumInteritemSpacing * 2) + 50
        )

        calendarCollectionView.collectionViewLayout = layout
        calendarCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension YearlyCalendarTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YearlyCalendarCollectionViewCell,
           let date = cell.baseDate
        {
            delegate?.goDetail(date)
        }
    }
}

extension YearlyCalendarTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dates?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YearlyCalendarCollectionViewCell.reuseIdentifier,
            for: indexPath)
        as! YearlyCalendarCollectionViewCell
        
        cell.baseDate = dates![indexPath.row]
        cell.initializeSubView()
        
        return cell
    }
}

class YearlyCalendarHeaderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: YearlyCalendarHeaderTableViewCell.self)
    
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class YearlyCalendarCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: YearlyCalendarCollectionViewCell.self)
    var baseDate: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeSubView() {
        let size = self.contentView.frame.size
        
        if let date = baseDate {
            
            let calendar = UIStoryboard(
                name: "Calendar",
                bundle: Bundle.main)
                .instantiateViewController(
                    withIdentifier: String(describing: CommonCalendarViewController.self)
            ) as! CommonCalendarViewController
            let calendarSize = CGSize(
                width: size.width,
                height: size.height + 50
            )
            
            calendar.startDate = date
            calendar.calendarSize = calendarSize
            self.contentView.addSubview(calendar.view)
            
        } else {
            fatalError("CommonCalendar CollectionView awakeFromNib Error(baseDate is nil)")
        }
    }
}

