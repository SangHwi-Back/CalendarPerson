//
//  MonthlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class MonthlyCalendarTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MonthlyCalendarTableViewCell.self)

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    var masterVC: UIViewController?
    
    var days: [Day]? {
        didSet {
            calendarCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.contentView.frame.width / 7, height: self.contentView.frame.width / 7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension MonthlyCalendarTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        masterVC?.performSegue(withIdentifier: "DailyScheduleViewController", sender: nil)
    }
}

extension MonthlyCalendarTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCollectionViewCell.reuseIdentifier, for: indexPath) as! MonthlyCollectionViewCell
        cell.dateLabel.text = (days?[indexPath.row].isWithinDisplayedMonth ?? false) ? days?[indexPath.row].number : ""
        return cell
    }
}

class MonthlyCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MonthlyCollectionViewCell.self)
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
