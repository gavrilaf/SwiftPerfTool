import XCTest

import SwiftPerfToolTests

var tests = [XCTestCaseEntry]()
tests += SwiftPerfToolTests.allTests()
XCTMain(tests)