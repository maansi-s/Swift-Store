//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    let name: String
    private let individualPrice: Int
    
    init(name: String, individualPrice: Int) {
        self.name = name
        self.individualPrice = individualPrice
    }
    
    func price() -> Int {
        return individualPrice
    }
}

class Receipt {
    private var scanned: [SKU] = []
    
    func add(_ item: SKU) {
        scanned.append(item)
    }
    
    func items() -> [SKU] {
        return scanned
    }
    
    func total() -> Int {
        return scanned.reduce(0) { total, item in
            total + item.price()
        }
    }
    
    func output() -> String {
        var result = "Receipt:\n"
        
        if !scanned.isEmpty {
            for item in scanned {
                let dollars = Double(item.price()) / 100.0
                result += "\(item.name): $\(String(format: "%.2f", dollars))\n"
            }
        }
        
        result += "------------------\n"
        
        let totalDollars = Double(total()) / 100.0
        result += "TOTAL: $\(String(format: "%.2f", totalDollars))"
        
        return result
    }
}

class Register {
    private var curr: Receipt
    
    init() {
        self.curr = Receipt()
    }
    
    func subtotal() -> Int {
        return curr.total()
    }
    
    func scan(_ item: SKU) {
        curr.add(item)
    }
    
    func total() -> Receipt {
        let finalReceipt = curr
        curr = Receipt()
        return finalReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
