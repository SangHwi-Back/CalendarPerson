//
//  CommonCalendarViewController.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/10/28.
//

import UIKit

class CommonCalendarViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var startDate: Date!
    var dateFormatter = DateFormatter()
    var daysGenerator: DaysOfMonthInCalendar!
    
    var calendarSize: CGSize!
    var showHeaderView: Bool = false
    var showFooterView: Bool = false
    var selectCellEnable: Bool = false
    
    var layout: UICollectionViewFlowLayout!
    var daysInMonth: [DayMetadata]!
    
    var itemViewContainer: UIView!
    
    var views: [[UIView]] = [[UIView]]()
    var stackViews: [UIStackView] = [UIStackView]()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysGenerator = (UIApplication.shared.delegate as! AppDelegate).daysGenerator
        dateFormatter.dateFormat = "MMM"
        headerLabel.text = dateFormatter.string(from: startDate)
        
        if startDate == nil {
            dismiss(animated: false, completion: nil)
        }
        
        daysInMonth = daysGenerator.generateDayInMonth(for: startDate)
        setMonthViews()
    }
    
    func setMonthViews() {
        
        for (index, day) in daysInMonth.enumerated() {
            
            let itemView = generateItemView()
            if day.isWithinDisplayedMonth {
                itemView.setViewContents(date: day)
            }
            
            setItemViewConstraint(
                view: itemView
                , coord: (
                    row: (Int(index / 7) + 1),
                    column: (Int(index % 7) + 1)
                )
            )
        }
    }
    
    func generateItemView() -> UIView {
        let itemView = UIView()
        itemView.frame.size = CGSize(width: 20, height: 20)
        return itemView
    }
    
    func setItemViewConstraint(view: UIView, coord: (row: Int, column: Int)) {
        
        if coord.column == 1 {
            
            contentViewHeightConstraint.constant = CGFloat(coord.row * 22)
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.frame.size = CGSize(width: contentStackView.frame.width, height: view.frame.height)
            
            contentStackView.addArrangedSubview(stackView)
        }
        
        (contentStackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(view)
    }
}

fileprivate extension UIView {
    func setViewContents(date: DayMetadata) {
        let label = UILabel()
        self.addSubview(label)
        label.textAlignment = .center
        label.text = date.number
        label.textColor = .label
        
        label.frame.size = self.frame.size
        label.center = self.center
    }
}
