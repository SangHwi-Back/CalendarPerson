import UIKit

var date = Date()
var calendar = Calendar.current

calendar.dateInterval(of: .year, for: date)
var dateComponent = calendar.dateComponents(in: TimeZone.current, from: date)


