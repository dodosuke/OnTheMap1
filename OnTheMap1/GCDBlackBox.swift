//
//  GCDBlackBox.swift
//  OnTheMap1
//
//  Created by Keisuke Kishida on 7/7/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}