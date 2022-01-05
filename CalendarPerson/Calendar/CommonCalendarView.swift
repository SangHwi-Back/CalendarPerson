//
//  CommonCalendarView.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/28.
//

import Foundation
import UIKit

class CommonCalendarView: UIView {
    
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    var baseDate: Date! {
        didSet {
            self.initializeCalendarView()
        }
    }
    
    var daysGenerator: DaysGenerator?
    var daysInMonth: [Day]!
    
    var contentViewHeight: CGFloat = 0 {
        didSet {
            self.contentViewHeightLayoutConstraint.constant = self.contentViewHeight
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeCalendarView() {
        
        daysGenerator = (UIApplication.shared.delegate as? AppDelegate)?.daysGenerator
        
        guard daysGenerator != nil else {
            return
        }
        
        if baseDate == nil {
            baseDate = Date()
        }
        
        dateFormatter.dateFormat = "MMM"
        headerLabel.text = dateFormatter.string(from: baseDate)
        daysInMonth = daysGenerator!.generateDayInMonth(for: baseDate)
        
        setConstraints() // Set Constraints
        
        daysInMonth.forEach { day in
            let itemView = generateItemView()
            if day.isWithinDisplayedMonth {
                itemView.setViewContents(date: day)
            }
        }
    }
    
    func setConstraints() {
        
        guard let view = superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraints = heightAnchor.constraint(equalTo: view.heightAnchor)
        
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
    
    func generateItemView() -> UIView {
        let itemView = UIView()
        itemView.frame.size = CGSize(width: 20, height: 20)
        return itemView
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
