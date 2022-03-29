//
//  DaysReformatter.swift
//  Pods
//
//  Created by 백상휘 on 2022/03/27.
//

import Foundation

protocol ResetDaysMetadata {
    func resetData()
}

class DaysReformatter {
    var resetMetadataDelegate: ResetDaysMetadata?
}
 
