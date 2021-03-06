import Foundation

public func reportMemory() throws -> UInt64 {
#if os(OSX)
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info)) / 4
    
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        task_info(mach_task_self_,
                  task_flavor_t(MACH_TASK_BASIC_INFO),
                  $0.withMemoryRebound(to: Int32.self, capacity: 1) { zeroPtr in task_info_t(zeroPtr) },
                  &count)
    }
    
    if kerr == KERN_SUCCESS {
        return UInt64(info.resident_size)
    }
    else {
        throw SPTError.memoryReport(String(validatingUTF8: mach_error_string(kerr)) ?? "unknown error")
    }
#else
    return 0
#endif
}

// MARK :-
func calcMemoryUsage(before: UInt64?, after: UInt64?) -> UInt64? {
    guard let before = before, let after = after else { return nil }
    let r = after.subtractingReportingOverflow(before)
    return r.overflow ? 0 : r.partialValue
}
