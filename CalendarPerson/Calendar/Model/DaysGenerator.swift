//
//  DaysGenerator.swift
//  CalendarPerson
//
//  Created by 백상휘 on 2021/11/02.
//

import Foundation

enum CalendarDataError: Error {
    case metadataGeneration
    case baseDateError
}

struct Day {
    let date: Date
    let number: String
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
}

class DaysGenerator {
    
    private(set) var calendar = Calendar.current
    private var dateFormatter = DateFormatter()
    private var modelDate: Date!
    
    init(baseDate: Date) {
        dateFormatter.dateFormat = "d"
        self.modelDate = baseDate
    }
    
    private func getMonthInfo(for baseDate: Date) throws -> MonthMetadata {
        
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekDay
        )
    }
    
    func generateDayInMonth() -> [Day] {
        return generateDayInMonth(for: modelDate)
    }
    
    func generateDayInMonth(for baseDate: Date) -> [Day] {
        
        guard let metadata = try? getMonthInfo(for: baseDate) else {
            fatalError("CommonCalendarViewController baseDate Error : \(baseDate)")
        }
        
        dateFormatter.dateFormat = "d"
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? (day - offsetInInitialRow) : -(offsetInInitialRow - day)
            
            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth
            )
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    private func generateStartOfNextMonth(
      using firstDayOfDisplayedMonth: Date
      ) -> [Day] {
      guard
        let lastDayInMonth = calendar.date(
          byAdding: DateComponents(month: 1, day: -1),
          to: firstDayOfDisplayedMonth)
        else {
          return []
      }

      let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
      guard additionalDays > 0 else {
        return []
      }

      let days: [Day] = (1...additionalDays)
        .map {
          generateDay(
          offsetBy: $0,
          for: lastDayInMonth,
          isWithinDisplayedMonth: false)
        }

      return days
    }
    
    private func generateDay(
      offsetBy dayOffset: Int,
      for baseDate: Date,
      isWithinDisplayedMonth: Bool
    ) -> Day {
      let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate

      return Day(
        date: date,
        number: dateFormatter.string(from: date),
        isSelected: calendar.isDate(date, inSameDayAs: modelDate),
        isWithinDisplayedMonth: isWithinDisplayedMonth
      )
    }
    
    func changeDateFormat(with format: String) {
        dateFormatter.dateFormat = format
    }
    
    func setCalendarType(with identifier: Calendar.Identifier) {
        calendar = Calendar(identifier: identifier)
    }
    
    func changeDate(with date: Date) {
        self.modelDate = date
    }
}
