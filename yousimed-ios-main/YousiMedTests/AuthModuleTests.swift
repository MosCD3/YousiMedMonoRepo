//
//  AuthModuleTests.swift
//  YousiMedTests
//
//  Created by Mostafa Gamal on 2022-01-18.
//
import XCTest
@testable import YousiMed

class AuthModuleTests: XCTestCase {
    
    let validator = Validator()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPasswordValidation() throws {
       
        // least one uppercase,
        // least one digit
        // least one lowercase
        //  min 8 characters total
        let passwordRegx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        XCTAssertTrue(validator.validateCustom(text: "MOSCDPAsS1", regEx: passwordRegx))
    }
    
    func testPasswordValidationComplex2() throws {
        
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        XCTAssertTrue(validator.validateCustom(text: "Moscd@pass1", regEx: passwordRegx))
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

