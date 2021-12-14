//
//  CommonCalendarView.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/28.
//

import Foundation
import UIKit

class CommonCalendarView: UIView {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentVerticalStackView: UIStackView!
    @IBOutlet weak var contentVerticalLayoutHeight: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
//    var calendarSize: CGSize!
    var dateFormatter = DateFormatter()
    var baseDate: Date! {
        didSet {
            self.initializeCalendarView()
        }
    }
    
    var daysGenerator: DaysGenerator?
    var daysInMonth: [Day]!
    
    var headerViewIsHidden = false
    var footerViewIsHidden = false
    
//    convenience init(size: CGSize, date: Date, isHeaderHidden: Bool = true, isFooterHidden: Bool = true) {
//        self.init(size: size)
//        self.baseDate = date
//        self.headerViewIsHidden = isHeaderHidden
//        self.footerViewIsHidden = isFooterHidden
//        self.awakeFromNib()
//    }
//
//    init(size: CGSize) {
//        self.calendarSize = size
//        super.init(frame: CGRect(origin: CGPoint.zero, size: size))
//    }
//
//    required init?(coder: NSCoder) {
//        self.calendarSize = CGSize()
//        super.init(coder: coder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.initializeCalendarView()
    }
    
    func initializeCalendarView() {
        
        daysGenerator = (UIApplication.shared.delegate as? AppDelegate)?.daysGenerator
        
        guard daysGenerator != nil else {
            return
        }
        
        if baseDate == nil {
            baseDate = Date()
        }
        
        headerView.isHidden = headerViewIsHidden
        footerView.isHidden = footerViewIsHidden
        dateFormatter.dateFormat = "MMM"
        headerLabel.text = dateFormatter.string(from: baseDate)
        daysInMonth = daysGenerator!.generateDayInMonth(for: baseDate)
//        let aa: Int = daysInMonth.firstIndex(where: {$0.number == "0"})!
        
        setConstraints() // Set Constraints
        
        setMonthViews()
    }
    
    func setConstraints() {
        
        guard let view = superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraints = heightAnchor.constraint(equalTo: view.heightAnchor)
//        heightConstraints.priority = UILayoutPriority(750)
        
        [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            widthAnchor.constraint(equalTo: view.widthAnchor),
            heightConstraints
        ].forEach {
            $0?.isActive = true
        }
    }
    
    func setMonthViews() {
        
        for (index, day) in daysInMonth.enumerated() {
            
            let itemView = generateItemView()
            if day.isWithinDisplayedMonth {
                itemView.setViewContents(date: day)
            }
            
            self.setItemViewConstraint(
                view: itemView
                , coord: (row: (Int(index / 7) + 1), column: (Int(index % 7) + 1))
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
            
            contentVerticalLayoutHeight.constant = CGFloat(coord.row * 22)
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.frame.size = CGSize(width: contentVerticalStackView.frame.width, height: view.frame.height)
            
            contentVerticalStackView.addArrangedSubview(stackView)
        }
        
        (contentVerticalStackView.arrangedSubviews.last as? UIStackView)?.addArrangedSubview(view)
    }
}

fileprivate extension UIView {
    func setViewContents(date: Day) {
        let label = UILabel()
        self.addSubview(label)
        label.textAlignment = .center
        label.text = date.number
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        [
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            , label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            , label.topAnchor.constraint(equalTo: self.topAnchor)
            , label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ].forEach {
            $0.isActive = true
        }
    }
}
