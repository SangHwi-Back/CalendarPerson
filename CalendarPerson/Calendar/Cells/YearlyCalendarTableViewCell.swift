//
//  YearlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class YearlyCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var masterVC: UIViewController?
    var date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.dataSource = self
        calendarCollectionViewFlowLayout.itemSize = CGSize(width: ((self.contentView.frame.size.width / 3) - 16),
                                                           height: ((self.contentView.frame.size.width / 3) - 16))
        calendarCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        calendarCollectionViewFlowLayout.minimumInteritemSpacing = 16
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "YearlyCalendarCollectionViewCell", for: indexPath)
    }
}





