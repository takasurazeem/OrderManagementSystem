//
//  ConsolePrinter.swift
//  OrderManagementSystem
//
//  Created by Amer Hukić on 25. 1. 2021..
//

import os.log
import Foundation

struct ConsolePrinter: Printer {
  private let queue = DispatchQueue(label: "console.printer.serial.queue")
  private let logger = Logger()
  
  func print(_ item: String) {
    print([item])
  }

  func print(_ items: [String]) {
    queue.async {
      items.forEach {
        self.logger.info("\($0)")
      }
    }
  }
}
