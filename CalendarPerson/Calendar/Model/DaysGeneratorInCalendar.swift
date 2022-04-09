//
//  DaysGeneratorInCalendar.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2022/03/23.
//

import Foundation

class DaysGeneratorInCalendar: DaysReformatter {
    
    // MARK: - Local Properties
    
    private(set) var baseDate: Date
    private(set) var localCalendar = Calendar.current
    private(set) var dateFormatter = DateFormatter()
    private(set) var daysComponents: Set<Calendar.Component> = [.year,.month,.day,.weekOfMonth]
    
    // MARK: - Designated Init
    
    init(_ dateFormatString: String, in date: Date? = nil) {
        dateFormatter.dateFormat = dateFormatString
        baseDate = date ?? Date()
    }
    
    // MARK: - Set Local Property
    
    func setCalendar(_ calendar: Calendar, ignoreReset: Bool = false) {
        self.localCalendar = calendar
        if ignoreReset == false {
            resetMetadataDelegate?.resetData()
        }
    }
    
    func setDate(base: Date, ignoreReset: Bool = false) {
        self.baseDate = base
        if ignoreReset == false {
            resetMetadataDelegate?.resetData()
        }
    }
    
    func changeDateFormat(with format: String, ignoreReset: Bool = false) {
        dateFormatter.dateFormat = format
        if ignoreReset == false {
            resetMetadataDelegate?.resetData()
        }
    }
    
    enum DataError: String, Error {
        case ErrorCalendarProperties
        case ErrorResetData
    }
}
