//
//  DateFormatter+Extension.swift
//  PokerGraph
//
//  Created by João Campos on 20/12/2023.
//

import Foundation

extension DateFormatter {

    static let customFormat: DateFormatter = {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyyy hh:mm:ss a"

        return dateFormatter
    }()
}
