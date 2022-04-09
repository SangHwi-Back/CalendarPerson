//
//  DaysOfYearInCalendar.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/03/27.
//

import Foundation

struct YearMetadata {
    let date: Date
    let components: DateComponents
    
    var monthsMetadata: [Int: MonthMetadata]?
}

class DaysOfYearInCalendar: DaysOfMonthInCalendar {
    
    // MARK: - Local property
    private(set) var yearMetadata: YearMetadata?
    private(set) var currentYear: Int
    
    private var firstDayOfYear: Date? {
        localCalendar.date(byAdding: .year, value: 0, to: baseDate)
    }
    
    // MARK: - Designated Init
    
    convenience init(current calendar: Calendar, formatString format: String, date: Date = Date(), startYear: Int? = nil) {
        
        let comp = calendar.dateComponents([.year], from: date)
        var date = date
        
        guard
            let startYear = startYear,
            let currentYear = comp.year,
            let startDate = calendar.date(byAdding: .year, value: startYear - currentYear, to: date)
        else {
            self.init(current: calendar, formatString: format, date: date)
            return
        }
        
        date = startDate
        self.init(current: calendar, formatString: format, date: date)
    }
    
    override init(current calendar: Calendar, formatString format: String, date: Date = Date()) {
        self.currentYear = calendar.dateComponents([.year], from: date).year!
        super.init(current: calendar, formatString: format, date: date)
    }
    
    @discardableResult
    func setYear(_ year: Int) -> Bool {
        guard let date = localCalendar.date(bySetting: .year, value: year, of: baseDate) else {
            return false
        }
        
        setDate(base: date)
        return true
    }
    
    func getYearMetadata() throws -> YearMetadata {
        
        guard let date = firstDayOfYear else {
            throw DataError.YearMetadataGenerateError
        }
        
        var metadata = YearMetadata(
            date: date,
            components: localCalendar.dateComponents([.year], from: date)
        )
        
        metadata.monthsMetadata = getDaysOfYearMetadata()
        yearMetadata = metadata
        return metadata
    }
    
    func getPreviousYearMetadata(from metadata: YearMetadata? = nil) throws -> YearMetadata {
        guard let date = localCalendar.date(byAdding: .year, value: -1, to: metadata?.date ?? baseDate) else {
            throw DataError.YearMetadataGenerateError
        }
        
        setDate(base: date)
        return try getYearMetadata()
    }
    
    func getNextYearMetadata(from metadata: YearMetadata? = nil) throws -> YearMetadata {
        guard let date = localCalendar.date(byAdding: .year, value: 1, to: metadata?.date ?? baseDate) else {
            throw DataError.YearMetadataGenerateError
        }
        
        setDate(base: date)
        return try getYearMetadata()
    }
    
    private func getDaysOfYearMetadata() -> [Int: MonthMetadata] {
        
        let oldBaseDate = baseDate
        let currentMonth = localCalendar.component(.month, from: baseDate)
        
        guard let date = localCalendar.date(byAdding: .month, value: ((currentMonth-1) * -1), to: oldBaseDate) else {
            return [Int:MonthMetadata]()
        }
        
        setDate(base: date)
        
        guard let metadata = try? getMonthMetadata() else {
            return [Int:MonthMetadata]()
        }
        
        var yearResult = [Int: MonthMetadata]()
        yearResult[1] = metadata
        
        for position in 2...12 {
            if let nextdata = try? getNextMonthMetadata() {
                yearResult[position] = nextdata
            }
        }
        
        setDate(base: oldBaseDate)
        
        return yearResult
    }
    
    enum DataError: String, Error {
        case YearMetadataGenerateError
    }
    
    func dateCompare(with date: Date) -> Bool {
        return localCalendar.component(.year, from: baseDate) == localCalendar.component(.year, from: date)
    }
}
