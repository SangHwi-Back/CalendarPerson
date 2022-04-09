//
//  DayInCalendar.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/03/23.
//

import Foundation

struct DayMetadata {
    let date: Date
    let components: DateComponents
    let isSelected: Bool
    let day: String
    let isOccupied: Bool
}

class DayInCalendar: DaysGeneratorInCalendar {
    
    // MARK: - Local Property
    
    private(set) var dayMetadata: DayMetadata?
    
    // MARK: - Designated Init
    
    override init(_ dateFormatString: String, in date: Date? = nil) {
        super.init(dateFormatString, in: date)
        
        do {
            let metadata = try getDayMetadata()
            self.dayMetadata = metadata
        } catch {
            print(error)
        }
    }
    
    // MARK: - Common Utilities
    
    func getDayMetadata() throws -> DayMetadata {
        
        let component = localCalendar.dateComponents(daysComponents, from: baseDate)
        guard let day = component.day else { throw DataError.DaysMetadataGenerateError }
        
        let firstDay = localCalendar.component(.weekday, from: baseDate)
        
        return DayMetadata(
            date: baseDate,
            components: localCalendar.dateComponents(daysComponents, from: baseDate),
            isSelected: false,
            day: "\(day)",
            isOccupied: firstDay >= day
        )
    }
    
    @discardableResult
    func getPreviousDayMetadata() throws -> DayMetadata {
        guard let date = localCalendar.date(byAdding: .day, value: -1, to: baseDate) else {
            throw DataError.DaysMetadataGenerateError
        }
        
        setDate(base: date)
        
        return try getDayMetadata()
    }
    
    @discardableResult
    func getNextDayMetadata() throws -> DayMetadata {
        guard let date = localCalendar.date(byAdding: .day, value: 1, to: baseDate) else {
            throw DataError.DaysMetadataGenerateError
        }
        
        setDate(base: date)
        
        return try getDayMetadata()
    }
    
    enum DataError: String, Error {
        case DaysMetadataGenerateError
    }
}
