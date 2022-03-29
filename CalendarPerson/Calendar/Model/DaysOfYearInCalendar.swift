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
    
    var monthsMetadata: [MonthMetadata]?
}

class DaysOfYearInCalendar: DaysOfMonthInCalendar {
    
    // MARK: - Local property
    private(set) var yearMetadata: YearMetadata?
    
    private var firstDayOfYear: Date? {
        localCalendar.date(byAdding: .year, value: 0, to: baseDate)
    }
    
    // MARK: - Designated Init
    
    override init?(current calendar: Calendar, formatString format: String, date: Date = Date()) {
        super.init(current: calendar, formatString: format, date: date)
        
        do {
            let metadata = try getYearMetadata()
            self.yearMetadata = metadata
        } catch {
            print(error)
            return nil
        }
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
    
    private func getDaysOfYearMetadata() -> [MonthMetadata] {
        guard let metadata = try? getMonthMetadata() else {
            return [MonthMetadata]()
        }
        
        var result = [metadata]
        
        for _ in 2...12 {
            if let nextdata = try? getNextMonthMetadata() {
                result.append(nextdata)
            }
        }
        
        return result
    }
    
    enum DataError: String, Error {
        case YearMetadataGenerateError
    }
}
