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
    
    var masterVC: UIViewController?
    var dates: [Date]? {
        didSet {
            self.calendarCollectionView.reloadData()
        }
    } // previousMonthFirstDay, currentMonthFirstDay, nextMonthFirstDay
    
    private lazy var viewWidth: CGFloat = {
        if self.contentView.frame.width <= (masterVC?.view.frame.width ?? 0) { return masterVC!.view.frame.width }
        return self.contentView.frame.width
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        layout.itemSize = CGSize(width: ((viewWidth / 3) - 16), height: ((viewWidth / 3) - 16))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        calendarCollectionView.collectionViewLayout = layout
        calendarCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension YearlyCalendarTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        masterVC?.performSegue(withIdentifier: "MonthlyCalendarViewController", sender: nil)
    }
}

extension YearlyCalendarTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (dates?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearlyCalendarCollectionViewCell.reuseIdentifier, for: indexPath) as! YearlyCalendarCollectionViewCell
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
            let calendar = UIStoryboard(name: "Calendar", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommonCalendarViewController") as! CommonCalendarViewController
            calendar.startDate = date
            calendar.calendarSize = CGSize(width: size.width, height: size.height+30)
            
//            let vc = CommonCalendarViewController(date: date, size: CGSize(width: size.width / 3, height: size.height))
            self.contentView.addSubview(calendar.view)
            
        } else {
            fatalError("CommonCalendar CollectionView awakeFromNib Error(baseDate is nil)")
        }
    }
}

