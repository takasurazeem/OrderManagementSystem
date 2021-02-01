//
//  OrderPickupManager.swift
//  OrderManagementSystem
//
//  Created by Amer Hukić on 26. 1. 2021.
//

import Foundation

class OrderPickupManager {
  private let container: CourierOrderPickupContainer
  private let uptimeTracker: UptimeTracking
  private let lock = NSLock()
  
  init(container: CourierOrderPickupContainer,
       uptimeTracker: UptimeTracking = UptimeTracker()) {
    self.container = container
    self.uptimeTracker = uptimeTracker
  }
  
  func sendCourierForPickup(_ courier: Courier, onOrderPickedUp orderPickupHandler: (TimeIntervalMilliseconds) -> Void) {
    let timePoint = uptimeTracker.currentUptimeMilliseconds()
    lock.lock()
    defer {
      lock.unlock()
    }
    guard let orderData = container.getOrderData(forCourier: courier) else {
      container.storeCourierData(CourierData(courier: courier, arrivalTimePoint: timePoint))
      return
    }
    let timeDifferenceMs = timePoint.absoluteDifference(from: orderData.preparationTimePoint)
    orderPickupHandler(timeDifferenceMs)
  }
  
  func sendOrderForPickup(_ order: Order, onOrderPickedUp orderPickupHandler: (TimeIntervalMilliseconds) -> Void) {
    let timePoint = uptimeTracker.currentUptimeMilliseconds()
    lock.lock()
    defer {
      lock.unlock()
    }
    guard let courierData = container.getCourierData(forOrder: order) else {
      container.storeOrderData(OrderData(order: order, preparationTimePoint: timePoint))
      return
    }
    let timeDifferenceMs = timePoint.absoluteDifference(from: courierData.arrivalTimePoint)
    orderPickupHandler(timeDifferenceMs)
  }
}
