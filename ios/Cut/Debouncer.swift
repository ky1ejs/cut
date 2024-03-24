//
//  Debouncer.swift
//  Cut
//
//  Created by Kyle Satti on 3/23/24.
//

import Foundation

class Debouncer {
    var timer: Timer?
    let delay: TimeInterval

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func debounce(_ closure: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            closure()
        }
    }
}

