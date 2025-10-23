# MGPerfMonitorApp
在主线程注册一个 CFRunLoopObserver，监听 RunLoop 的状态变化

MGPerfMonitor/
├─ Package.swift
├─ README.md
├─ Sources/PerfMonitor/
│  ├─ MGPerfMonitor.swift        // 联合入口 + Combine + HUD 调度
│  ├─ MGFPSMonitor.swift         // CADisplayLink -> FPS publisher
│  ├─ MGLagMonitor.swift         // RunLoop observer + 主线程堆栈采样
│  ├─ MGPerfHUD.swift            // 可拖拽 / 可折叠 HUD
│  ├─ MGPerfLogger.swift         // 日志写入 + 轮转 + 上报
│  └─ MGStackSampler.swift       // 精确堆栈符号化
