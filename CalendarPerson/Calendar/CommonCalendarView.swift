//
//  CommonCalendarView.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/28.
//

import Foundation
import UIKit

/// 1개월 분의 달력을 보여줍니다.
class CommonCalendarView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Local Properties
    var monthMetadata: MonthMetadata! {
        didSet {
            initializeCalendarView()
        }
    }
    private var currentSetLabel: UILabel?
    
    private var labelSizeProperty: CGFloat {
        (self.frame.size.width / 7) - labelPadding
    }
    
    private var labelPadding: CGFloat {
        (self.frame.size.width / 7) / 7
    }
    
    private var commonCalendarLabels = [CommonCalendarDayLabel]()
    
    // MARK: - Initializers
    convenience init(frame: CGRect, monthMetadata: MonthMetadata) {
        self.init(frame: frame)
        self.monthMetadata = monthMetadata
    }
    
    func initializeCalendarView() {
        
        guard let dayMetadata = monthMetadata.dayMetadata else { return }
        
        headerLabel.text = monthMetadata.monthName
        
        var rowNumber = -1
        for (index, dataOfDay) in dayMetadata.enumerated() {
            rowNumber += (index % 7 == 0 ? 1 : 0)
            generateItemView(at: index, day: dataOfDay.day, on: rowNumber)
        }
    }
    
    func generateItemView(at index: Int, day: String, on rowNumber: Int) {
        
        if contentView.subviews.count-1 >= index, let label = contentView.subviews[index] as? CommonCalendarDayLabel {
            label.text = day
            return
        }
        
        let label = CommonCalendarDayLabel(frame: CGRect(
            x: CGFloat(index % 7) * labelSizeProperty,
            y: CGFloat(rowNumber) * labelSizeProperty,
            width: labelSizeProperty,
            height: labelSizeProperty)
        )
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = CGFloat(0.3)
        
        contentView.addSubview(label)
        
        label.textAlignment = .right
        label.text = day
        label.textColor = .label
        
        currentSetLabel = label
    }
}

class CommonCalendarDayLabel: UILabel { }
