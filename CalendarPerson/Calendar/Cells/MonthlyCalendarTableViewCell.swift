//
//  MonthlyCalendarTableViewCell.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/25.
//

import UIKit

class MonthlyCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    var masterVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MonthlyCalendarTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        masterVC?.performSegue(withIdentifier: "DailyScheduleViewController", sender: nil)
    }
}

extension MonthlyCalendarTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthlyCollectionViewCell", for: indexPath)
        
        return cell
    }
}
