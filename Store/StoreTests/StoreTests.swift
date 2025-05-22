//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {
    
    var register = Register()
    
    override func setUpWithError() throws {
        register = Register()
    }
    
    override func tearDownWithError() throws { }
    
    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", individualPrice: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", individualPrice: 199))
        register.scan(Item(name: "Beans (8oz Can)", individualPrice: 199))
        register.scan(Item(name: "Beans (8oz Can)", individualPrice: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", individualPrice: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", individualPrice: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", individualPrice: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())
        
        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New tests staring here:
    
    func testEmptyReceiptOutput() {
        let receipt = register.total()
        let expectedOutput = """
Receipt:
------------------
TOTAL: $0.00
"""
        XCTAssertEqual(expectedOutput, receipt.output())
    }
    
    func testEmptyRegisterSubtotal() {
        XCTAssertEqual(0, register.subtotal())
    }
    
    func testEmptyReceiptTotal() {
        let receipt = register.total()
        XCTAssertEqual(0, receipt.total())
    }
    
    func testReceiptItems() {
        register.scan(Item(name: "Apple", individualPrice: 50))
        register.scan(Item(name: "Orange", individualPrice: 75))
        
        let receipt = register.total()
        let items = receipt.items()
        
        XCTAssertEqual(2, items.count)
        XCTAssertEqual("Apple", items[0].name)
        XCTAssertEqual("Orange", items[1].name)
        XCTAssertEqual(50, items[0].price())
        XCTAssertEqual(75, items[1].price())
    }
    
    func testRegisterResetsAfterTotal() {
        register.scan(Item(name: "Test Item", individualPrice: 100))
        XCTAssertEqual(100, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(100, receipt.total())
        XCTAssertEqual(0, register.subtotal())
    }
    
    func testMultipleTransactions() {
        
        register.scan(Item(name: "Item1", individualPrice: 100))
        register.scan(Item(name: "Item2", individualPrice: 200))
        let firstReceipt = register.total()
        XCTAssertEqual(300, firstReceipt.total())
        
        register.scan(Item(name: "Item3", individualPrice: 150))
        let secondReceipt = register.total()
        XCTAssertEqual(150, secondReceipt.total())
        
        XCTAssertEqual(300, firstReceipt.total())
    }
    
    func testItemWithZeroPrice() {
        let freeItem = Item(name: "Free Sample", individualPrice: 0)
        register.scan(freeItem)
        
        XCTAssertEqual(0, register.subtotal())
        XCTAssertEqual("Free Sample", freeItem.name)
        XCTAssertEqual(0, freeItem.price())
    }
    
    func testItemPriceMethod() {
        let item = Item(name: "Test Product", individualPrice: 299)
        
        XCTAssertEqual("Test Product", item.name)
        XCTAssertEqual(299, item.price())
    }
    
}
    
