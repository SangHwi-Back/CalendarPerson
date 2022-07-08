//
//  MonthOfDays.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/02.
//

import Foundation

struct MonthMetadata: Hashable {
    
    let date: Date
    let components: DateComponents
    var numberOfDays: Int {
        dayMetadata?.count ?? 0
    }
    
    var monthName: String
    
    var dayMetadata: [DayMetadata]?
    
    static func == (lhs: MonthMetadata, rhs: MonthMetadata) -> Bool {
        lhs.date == rhs.date
    }
}

class DaysOfMonthInCalendar: DayInCalendar {
    
    // MARK: - Local Properties
    
    /// 현재 인스턴스가 가리키고 있는 메타데이터
    private(set) var monthMetadata: MonthMetadata?
    
    // MARK: - DateComponents Closures
    
    /// 파라미터로 전달되는 Bool 값에 따라 메타데이터가 가리키는 Month의 첫째날 혹은 마지막날 Date 객체를 가져온다.
    private func getEdgeDate(atFirst: Bool) -> Date? {
        let num = (atFirst ? -1 : 0)
        guard let date = localCalendar.date(byAdding: .month, value: num, to: baseDate) else { return nil}
        return localCalendar.date(byAdding: .day, value: (num * -1), to: date)
    }
    
    /// 현재 메타데이터가 가리키고 있는 Month의 첫째날에 해당하는 DateComponents
    private var monthComponentsInFirstDay: DateComponents? {
        guard let targetDate = getEdgeDate(atFirst: true) else { return nil }
        return localCalendar.dateComponents([.day], from: targetDate)
    }
    
    /// 현재 메타데이터가 가리키고 있는 Month의 마지막날에 해당하는 DateComponents
    private var monthComponentsInEndDay: DateComponents? {
        guard let targetDate = getEdgeDate(atFirst: false) else { return nil }
        return localCalendar.dateComponents([.day], from: targetDate)
    }
    
    // MARK: - Designated Init
    
    init(current calendar: Calendar, formatString format: String, date: Date = Date()) {
        super.init(format, in: date)
    }
    
    // MARK: - Common Utilities
    
    func getPreviousMonthMetadata(from metadata: MonthMetadata? = nil) throws -> MonthMetadata {
        guard let date = localCalendar.date(byAdding: .month, value: -1, to: metadata?.date ?? baseDate) else {
            throw DataError.MonthMetadataGenerateError
        }
        
        setDate(base: date)
        return try getMonthMetadata()
    }
    
    func getNextMonthMetadata(from metadata: MonthMetadata? = nil) throws -> MonthMetadata {
        guard let date = localCalendar.date(byAdding: .month, value: 1, to: metadata?.date ?? baseDate) else {
            throw DataError.MonthMetadataGenerateError
        }
        
        setDate(base: date)
        return try getMonthMetadata()
    }
    
    func getMonthMetadata() throws -> MonthMetadata {
        
        monthMetadata = MonthMetadata(
            date: baseDate,
            components: localCalendar.dateComponents(daysComponents, from: baseDate),
            monthName: getMonthName()
        )
        
        monthMetadata!.dayMetadata = try getDaysInMonthMetadata()
        return monthMetadata!
    }
    
    private func getDaysInMonthMetadata() throws -> [DayMetadata] {
        
        var result = [DayMetadata]()
        guard
            var date = getEdgeDate(atFirst: true),
            let numberOfDays = localCalendar.range(of: .day, in: .month, for: date)?.count
        else {
            return result
        }
        
        let monthOffset = localCalendar.component(.weekday, from: date)
        
        for day in 1...monthOffset+numberOfDays {
            result.append(
                DayMetadata(
                    date: date,
                    components: localCalendar.dateComponents([.year, .month], from: date),
                    isSelected: false,
                    day: (monthOffset >= day ? "" : "\(day-monthOffset)"),
                    isOccupied: (monthOffset >= day)
                )
            )
            
            if let targetDate = localCalendar.date(byAdding: .day, value: 1, to: date) {
                date = targetDate
            }
        }
        
        return result
    }
    
    func getMonthName() -> String {
        let oldFormat = dateFormatter.dateFormat
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale.current
        
        defer {
            dateFormatter.dateFormat = oldFormat
        }
        
        return dateFormatter.string(from: baseDate)
    }
    
    enum DataError: String, Error {
        case MonthMetadataGenerateError
        case MonthFirstOrEndDayGenerateError
        case ConvertDayMetadataFailed
    }
}
