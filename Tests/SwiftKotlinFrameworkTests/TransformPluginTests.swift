//
//  TransformPluginTests.swift
//  SwiftKotlinFrameworkTests
//
//  Created by Angel Luis Garcia on 14/10/2017.
//

import XCTest
@testable import SwiftKotlinFramework

class TransformPluginTests: XCTestCase {
    
    func testXCTestToJUnitPlugin() {        
        try! testTokenTransformPlugin(
            plugin: XCTTestToJUnitTokenTransformPlugin(),
            file: "XCTTestToJUnitTokenTransformPlugin")
    }

}

extension TransformPluginTests {
    
    private func testTokenTransformPlugin(plugin: TokenTransformPlugin, file: String) throws {
        let kotlinTokenizer = KotlinTokenizer()
        kotlinTokenizer.sourceTransformPlugins = []
        kotlinTokenizer.tokenTransformPlugins = [plugin]

        let path = self.testFilePath
        let swiftURL = URL(fileURLWithPath: "\(path)/\(file).swift")
        let kotlinURL = URL(fileURLWithPath: "\(path)/\(file).kt")

        let expected = try String(contentsOf: kotlinURL).trimmingCharacters(in: .whitespacesAndNewlines)
        let translated = try kotlinTokenizer.translate(path: swiftURL).joinedValues().trimmingCharacters(in: .whitespacesAndNewlines)

        if translated != expected {
            let difference = prettyFirstDifferenceBetweenStrings(translated, expected)
            NSLog("❌ \(file)")
            XCTFail(difference)
        } else {
            NSLog("✅ \(file)")
        }
    }

    private var testFilePath: String {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Tests")
            .appendingPathComponent("plugins")
            .path
    }
}
