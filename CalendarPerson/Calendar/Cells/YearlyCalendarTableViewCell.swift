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
    
    var segueDelegate: YearlyTableViewSegueDelegate?
    var dataFetchDelegate: YearlyTableViewDateFetchDelegate?
    var datesinCells: [UIViewController]!
    var year: String!
    
    private lazy var viewWidth: CGFloat = floor(self.calendarCollectionView.frame.width)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.removeFromSuperview()
        let calendar = OneYearCalendarView(rect: contentView.frame, date: Date())
        self.contentView.addSubview(calendar)
        calendar.gridYearView()
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
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YearlyCalendarCollectionViewCell.reuseIdentifier,
            for: indexPath)
        as! YearlyCalendarCollectionViewCell
        
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

class OneYearCalendarView: UIView {
    
    var date: Date!
    var oneYearDates = [Date]()
    var yearViewGrid = [UIStackView]()
    let dateFormatter = DateFormatter()
    
    convenience init(rect: CGRect, date: Date) {
        
        if rect.width < 300 && rect.height < 400 {
            fatalError("OneYearCalendarView frame must excess width:300, height:400")
        }
        
        self.init(frame: rect)
        self.dateFormatter.dateFormat = "MMM"
        self.date = date
        self.generateOneYearDateArray()
    }
    
    private func generateOneYearDateArray() {
        
        var baseComponent = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        for i in 1...12 {
            baseComponent.month = i
            if let safeDate = Calendar.current.date(from: baseComponent) {
                oneYearDates.append(safeDate)
            }
        }
    }
    
    func gridYearView() {
        
        guard let sView = superview else {
            return
        }
        
        let vStack = UIStackView()
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 18
        vStack.axis = .vertical
        
        sView.addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        [
            vStack.leftAnchor.constraint(equalTo: sView.leftAnchor, constant: 16),
            vStack.rightAnchor.constraint(equalTo: sView.rightAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: sView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: sView.bottomAnchor),
            vStack.centerXAnchor.constraint(equalTo: sView.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: sView.centerYAnchor)
        ].forEach {
            $0.isActive = true
        }
        
        for _ in 0..<4 {
            
            let hStack = UIStackView()
            hStack.alignment = .top
            hStack.distribution = .fillEqually
            hStack.spacing = 2
            hStack.axis = .horizontal
            vStack.addArrangedSubview(hStack)
            
            yearViewGrid.append(hStack)
        }
        
        for (inx, date) in oneYearDates.enumerated() {
            setGridContents(date: date, &yearViewGrid[Int(inx/3)])
            
//            if (inx + 1) % 3 == 0 {
//                yearViewGrid[Int(inx/3)].setNeedsLayout()
//                yearViewGrid[Int(inx/3)].layoutIfNeeded()
//            }
        }
    }
    
    private func setGridContents(date: Date, _ stackView: inout UIStackView) {
        
        guard let daysGenerator = (UIApplication.shared.delegate as! AppDelegate).daysGenerator else {
            return
        }
        
        guard let commonCalendarView = Bundle.main.loadNibNamed(String(describing: CommonCalendarView.self), owner: self, options: nil)?.first as? CommonCalendarView else {
            return
        }
        
        commonCalendarView.headerLabel.text = dateFormatter.string(from: date)
        commonCalendarView.footerView.isHidden = true
        
        let daysInMonth = daysGenerator.generateDayInMonth(for: date)
        let width = Int(commonCalendarView.parentStackView.frame.width / 21)
        
        for (inx, day) in daysInMonth.enumerated() {
            
            let itemView = UILabel(
                frame: CGRect(
                    origin: CGPoint(x: width * (inx % 7), y: width * Int((inx) / 7)),
                    size: CGSize(width: width, height: width)
                )
            )
            itemView.textAlignment = .right
            itemView.adjustsFontSizeToFitWidth = true
            
            if day.isWithinDisplayedMonth {
                itemView.text = day.number
            }
            
            commonCalendarView.contentView.addSubview(itemView)
            
            if inx == daysInMonth.count - 1 {
                commonCalendarView.contentViewHeight = itemView.frame.maxY
            }
        }
        
        stackView.addArrangedSubview(commonCalendarView)
        
        if
            let labels = commonCalendarView.contentView.subviews as? [UILabel],
            let minLabelFont = labels.min(by: { $0.font.pointSize < $1.font.pointSize } )?.font
        {
            
            print(minLabelFont.pointSize, commonCalendarView.parentStackView.frame.height)
            labels.forEach { $0.font = minLabelFont }
//            stackView.frame.size.height = commonCalendarView.parentStackView.frame.height
        }
    }
}
