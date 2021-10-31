import UIKit

var date = Date()
var calendar = Calendar.current

let range = calendar.range(of: .day, in: .month, for: date)?.count
print(range!)

