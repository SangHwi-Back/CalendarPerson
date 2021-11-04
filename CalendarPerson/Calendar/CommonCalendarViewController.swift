//
//  CommonCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/28.
//

import UIKit

/*
 * startDate
 */
class CommonCalendarViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var startDate: Date!
    var dateFormatter = DateFormatter()
    var daysGenerator: CalendarDaysFactory!
    
    var calendarSize: CGSize!
    var showHeaderView: Bool = false
    var showFooterView: Bool = false
    var selectCellEnable: Bool = false
    
    var layout: UICollectionViewFlowLayout!
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
        self.daysGenerator = (UIApplication.shared.delegate as! AppDelegate).daysGenerator
        self.collectionView.isUserInteractionEnabled = selectCellEnable
        
        dateFormatter.dateFormat = "MMM"
        headerLabel.text = dateFormatter.string(from: startDate)
        
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        layout.itemSize = CGSize(width: calendarSize.width / 9, height: calendarSize.width / 8)
        self.view.frame.size = calendarSize
        
        collectionView.collectionViewLayout = layout
        
        if startDate == nil {
            dismiss(animated: false, completion: nil)
        }
        
        daysInMonth = daysGenerator.generateDayInMonth(for: startDate)
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
