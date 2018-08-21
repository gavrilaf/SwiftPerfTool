import Foundation

public func reportMemory() throws -> UInt64 {
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
}
