//
//  File.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/23.
//

import Foundation
import Darwin
import RunTime

public final class MGStackSampler {
    public static func sampleMainThreadSymbolized() -> [String] {
        let stackCount = 128
        let stack = UnsafeMutablePointer<UnsafeMutableRawPointer?>.allocate(capacity: stackCount)
        defer { stack.deallocate() }
        
        // ✅ backtrace 需要的是 UnsafeMutablePointer<UnsafeMutableRawPointer?>
        let count = backtrace(stack, Int32(stackCount))
        var result: [String] = []
        
        if count > 0 {
            if let symbols = backtrace_symbols(stack, count) {
                for i in 0..<Int(count) {
                    if let cString = symbols[i] {
                        result.append(String(cString: cString))
                    }
                }
                free(symbols)
            }
        }
        return result
    }
    
    /// 进阶：结合 atos / dSYM 实现行号解析（生产环境可选）
    /// 例如： atos -o MyApp.app/MyApp -l <loadAddress> <addr>
    public static func symbolicate(addresses: [UInt]) -> [String] {
        // 可实现 shell 调用 atos
        // 这里只返回占位符
        return addresses.map { "Symbolicated <\($0)>" }
    }
    
    
    public static func getSymbolicated() {
        do {
            if let frames = try? Backtrace.capture().symbolicated()?.frames {
                print(frames)
            } else {
                print("Failed to capture backtrace.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
