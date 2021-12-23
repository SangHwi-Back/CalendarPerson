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
    
    private let storyboard = UIStoryboard(name: "Calendar", bundle: Bundle.main)
    var segueDelegate: YearlyTableViewSegueDelegate?
    var dataFetchDelegate: YearlyTableViewDateFetchDelegate?
//    var datesInARow: [Date]? {
//        didSet {
//            calendarCollectionView.reloadData()
//            let height = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height
//            if height > calendarCollectionViewConstraintHeight.constant {
//                calendarCollectionViewConstraintHeight.constant = height
//                superview?.setNeedsLayout()
//                superview?.layoutIfNeeded()
//            }
//        }
//    } // previousMonthFirstDay, currentMonthFirstDay, nextMonthFirstDay
    
    var datesinCells: [UIViewController]!
    var alreadyInstalled = false
    var year: String!
    
    private lazy var viewWidth: CGFloat = floor(self.calendarCollectionView.frame.width)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.removeFromSuperview()
        let calendar = OneYearCalendarView(rect: contentView.frame, date: Date())
        self.contentView.addSubview(calendar)
        calendar.gridYearView()
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 0
//        if datesinCells == nil {
//            datesinCells = [UIViewController]()
//        }
//        layout.estimatedItemSize = CGSize(
//            width: (viewWidth / 3) - (self.layoutMargins.left + self.layoutMargins.right),
//            height: (viewWidth / 3)
//        )
//        calendarCollectionView.collectionViewLayout = layout
//        calendarCollectionView.reloadData()
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
        
//        cell.baseDate = datesInARow![indexPath.row]
//
//        if let calendarView =
//            Bundle.main.loadNibNamed(
//                String(describing: CommonCalendarView.self),
//                owner: self,
//                options: nil)?.first as? CommonCalendarView {
//
//            calendarView.footerViewIsHidden = true
//            calendarView.headerViewIsHidden = false
//            calendarView.baseDate = datesInARow![indexPath.row]
//
//            cell.contentView.addSubview(calendarView)
//
//            calendarView.initializeCalendarView()
//        }
//        let view = cell.initializeSubView().view!
//        view.frame = CGRect(origin: CGPoint.zero, size: cell.contentView.frame.size)
//        cell.contentView.addSubview(view)
        
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
    
//    override func addSubview(_ view: UIView) {
//        self.addSubview(view)
//        gridYearView()
//
//        for (inx, date) in oneYearDates.enumerated() {
//            setGridContents(date: date, yearViewGrid[Int(inx/3)])
//        }
//    }
    
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
        
        guard superview != nil else {
            return
        }
        
        let vStack = UIStackView()
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = 10
        vStack.axis = .vertical
        
        superview!.addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        [
            vStack.leftAnchor.constraint(equalTo: superview!.leftAnchor),
            vStack.rightAnchor.constraint(equalTo: superview!.rightAnchor),
            vStack.topAnchor.constraint(equalTo: superview!.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            vStack.centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ].forEach {
            $0.isActive = true
        }
        
        for _ in 0..<4 {
            
            let hStack = UIStackView()
            hStack.alignment = .fill
            hStack.distribution = .fillEqually
            hStack.spacing = 2
            hStack.axis = .horizontal
            vStack.addArrangedSubview(hStack)
            
//            hStack.translatesAutoresizingMaskIntoConstraints = false
//            hStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
            
            yearViewGrid.append(hStack)
        }
        
        for (inx, date) in oneYearDates.enumerated() {
            setGridContents(date: date, yearViewGrid[Int(inx/3)])
        }
    }
    
    private func setGridContents(date: Date, _ stackView: UIStackView) {
        
        guard let daysGenerator = (UIApplication.shared.delegate as! AppDelegate).daysGenerator else {
            return
        }
        
        guard let commonCalendarView = Bundle.main.loadNibNamed(String(describing: CommonCalendarView.self), owner: self, options: nil)?.first as? CommonCalendarView else {
            return
        }
        
        commonCalendarView.headerLabel.text = dateFormatter.string(from: date)
        commonCalendarView.footerView.isHidden = true
        
        let daysInMonth = daysGenerator.generateDayInMonth(for: date)
        let width = Int(superview!.frame.width / 21) // 20
        
        for (inx, day) in daysInMonth.enumerated() {
            
            let itemView = UILabel(
                frame: CGRect(
                    origin: CGPoint(x: width * (inx % 7), y: width * Int((inx+1) / 7)),
                    size: CGSize(width: width, height: width)
                )
            )
            itemView.adjustsFontSizeToFitWidth = true
            
            if day.isWithinDisplayedMonth {
                itemView.text = day.number
            }
            
            commonCalendarView.contentView.addSubview(itemView)
            
            if inx == daysInMonth.endIndex-1 {
//                DispatchQueue.main.async {
                    commonCalendarView.contentVerticalLayoutHeight.constant = itemView.frame.maxY
                    
                    if stackView.frame.height < itemView.frame.maxY {
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        stackView.heightAnchor.constraint(equalToConstant: itemView.frame.maxY).isActive = true
                    }
//                }
            }
        }
        
        stackView.addArrangedSubview(commonCalendarView)
    }
}
