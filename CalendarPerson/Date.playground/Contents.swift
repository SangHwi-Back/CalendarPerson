import UIKit

var date = Date()
var calendar = Calendar.current
var dateFormatter = DateFormatter()

let range = calendar.range(of: .day, in: .month, for: date)?.count
print(range!)

dateFormatter.dateFormat = "y"
print(dateFormatter.string(from: Date()))
