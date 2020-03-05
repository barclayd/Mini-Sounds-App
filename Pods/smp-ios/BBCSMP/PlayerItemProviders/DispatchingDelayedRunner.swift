//
//  DispatchingDelayedRunner.swift
//  SMP
//
//  Created by Raj Khokhar on 16/03/2018.
//  Copyright © 2018 BBC. All rights reserved.
//

import Foundation

public class DispatchingDelayedRunner: NSObject, DelayedRunner {

    public func scheduleAfter(_ delay: TimeInterval, block: @escaping () -> Void) {
        let time = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + UInt64(delay * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }

}
