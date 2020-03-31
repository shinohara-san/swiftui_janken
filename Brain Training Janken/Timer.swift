//
//  Timer.swift
//  Brain Training Janken
//
//  Created by Yuki Shinohara on 2020/03/31.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation

class JankenTimer : ObservableObject {
    
    @Published var counter = 10
    @Published var timeup = false
        
    var timer = Timer()
    
    func start() {
        counter = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.counter -= 1
            if self.counter == 0{
                self.timer.invalidate()
                self.timeup = true
             
            }
        }
    }
    
    func stop(){
        timer.invalidate()
    }
}
