//
//  File.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/23.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public final class MGPerfLogger {
    nonisolated(unsafe) public static let shared = MGPerfLogger()
    private let ioQueue = DispatchQueue(label: "com.perfmonitor.logger")
    private var currentFile: URL?
    private var maxFileSize: UInt64 = 1024 * 1024 // 1MB
    public var onUpload: ((String) -> Void)?
    
    private init() { rotateIfNeeded() }
    
    private func rotateIfNeeded() {
        let fm = FileManager.default
        if let currentFile = currentFile,
           let attr = try? fm.attributesOfItem(atPath: currentFile.path),
           let size = attr[.size] as? UInt64, size > maxFileSize {
            let date = ISO8601DateFormatter().string(from: Date())
            self.currentFile = fm.temporaryDirectory.appendingPathComponent("perf_\(date).txt")
        } else if currentFile == nil {
            let date = ISO8601DateFormatter().string(from: Date())
            currentFile = fm.temporaryDirectory.appendingPathComponent("perf_\(date).txt")
        }
    }
    
    public func log(_ string: String) {
        ioQueue.async {
            self.rotateIfNeeded()
            guard let file = self.currentFile else { return }
            let line = "[\(ISO8601DateFormatter().string(from: Date()))] \(string)\n"
            if FileManager.default.fileExists(atPath: file.path) {
                if let handle = try? FileHandle(forWritingTo: file) {
                    handle.seekToEndOfFile()
                    if let data = line.data(using: .utf8) { handle.write(data) }
                    try? handle.close()
                }
            } else {
                try? line.write(to: file, atomically: true, encoding: .utf8)
            }
            self.onUpload?(line)
        }
    }
}
