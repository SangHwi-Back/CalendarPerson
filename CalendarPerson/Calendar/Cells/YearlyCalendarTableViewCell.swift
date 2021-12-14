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
    
    private let storyboard = UIStoryboard(name: "Calendar", bundle: Bundle.main)
    var segueDelegate: YearlyTableViewSegueDelegate?
    var dataFetchDelegate: YearlyTableViewDateFetchDelegate?
    var datesInARow: [Date]? {
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
    
    var datesinCells: [UIViewController]!
    var alreadyInstalled = false
    var year: String!
    
    private lazy var viewWidth: CGFloat = floor(self.calendarCollectionView.frame.width)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        if datesinCells == nil {
            datesinCells = [UIViewController]()
        }
        
        layout.estimatedItemSize = CGSize(
            width: (viewWidth / 3) - (self.layoutMargins.left + self.layoutMargins.right),
            height: (viewWidth / 3)
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
            segueDelegate?.goDetail(date)
        }
    }
}

extension YearlyCalendarTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (datesInARow?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YearlyCalendarCollectionViewCell.reuseIdentifier,
            for: indexPath)
        as! YearlyCalendarCollectionViewCell
        
        cell.baseDate = datesInARow![indexPath.row]
        
        if let calendarView =
            Bundle.main.loadNibNamed(
                String(describing: CommonCalendarView.self),
                owner: self,
                options: nil)?.first as? CommonCalendarView {
            
            calendarView.footerViewIsHidden = true
            calendarView.headerViewIsHidden = false
            calendarView.baseDate = datesInARow![indexPath.row]
            
            cell.contentView.addSubview(calendarView)
            
            calendarView.initializeCalendarView()
        }
//        let view = cell.initializeSubView().view!
//        view.frame = CGRect(origin: CGPoint.zero, size: cell.contentView.frame.size)
//        cell.contentView.addSubview(view)
        
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
    
    func initializeSubView() -> UIViewController {
//        let size = self.contentView.frame.size
        
        if let date = baseDate {
            
            let calendar = UIStoryboard(
                name: "Calendar",
                bundle: Bundle.main)
                .instantiateViewController(
                    withIdentifier: String(describing: CommonCalendarViewController.self)
            ) as! CommonCalendarViewController
            
            let calendarSize = contentView.frame.size
            
            calendar.startDate = date
            calendar.calendarSize = calendarSize
            return calendar
        }
        
        return UIViewController()
    }
}

