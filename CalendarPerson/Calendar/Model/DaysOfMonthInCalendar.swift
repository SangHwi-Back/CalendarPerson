//
//  MonthOfDays.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/02.
//

import Foundation

struct MonthMetadata {
    let date: Date
    let components: DateComponents
    let numberOfDays: Int
    
    let firstDayInMonth: Int
    let endDayInMonth: Int
    
    var monthName: String
    
    var dayMetadata: [DayMetadata]?
}

class DaysOfMonthInCalendar: DayInCalendar {
    
    // MARK: - Local Properties
    
    /// 현재 인스턴스가 가리키고 있는 메타데이터
    private(set) var monthMetadata: MonthMetadata?
    
    // MARK: - DateComponents Closures
    
    /// 파라미터로 전달되는 Bool 값에 따라 메타데이터가 가리키는 Month의 첫째날 혹은 마지막날 Date 객체를 가져온다.
    private func getEdgeDate(atFirst: Bool) -> Date? {
        let num = (atFirst ? -1 : 1)
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
    
    // MARK: - Date Etcs...
    
    private var numberOfDaysInMonth: Int {
        self.localCalendar.range(of: .day, in: .month, for: self.baseDate)?.count ?? 0
    }
    
    // MARK: - Designated Init
    
    init?(current calendar: Calendar, formatString format: String, date: Date = Date()) {
        super.init(format, in: date)
        
        do {
            let metadata = try getMonthMetadata()
            self.monthMetadata = metadata
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Common Utilities
    
    func getMonthMetadata() throws -> MonthMetadata {
        
        guard
            let firstDay = monthComponentsInFirstDay?.day,
            let endDay = monthComponentsInEndDay?.day
        else {
            throw DataError.MonthMetadataGenerateError
        }
        
        monthMetadata = MonthMetadata(
            date: baseDate,
            components: localCalendar.dateComponents(daysComponents, from: baseDate),
            numberOfDays: numberOfDaysInMonth,
            firstDayInMonth: firstDay,
            endDayInMonth: endDay,
            monthName: getMonthName()
        )
        
        monthMetadata!.dayMetadata = try getDaysInMonthMetadata()
        return monthMetadata!
    }
    
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
    
    private func getDaysInMonthMetadata() throws -> [DayMetadata] {
        
        var result = [DayMetadata]()
        guard
            let numberOfDays = monthMetadata?.numberOfDays,
            var date = getEdgeDate(atFirst: true),
            let monthOffset = monthComponentsInFirstDay?.day
        else {
            return result
        }
        
        for day in 1...monthOffset+numberOfDays {
            result.append(
                DayMetadata(
                    date: date,
                    components: localCalendar.dateComponents([.year, .month], from: date),
                    isSelected: false,
                    day: "\(day)",
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
