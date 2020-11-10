import Foundation

struct DiskStatus {
  
  var fileManager: FileManager
  
  init(_ manager: FileManager = .default) {
    self.fileManager = manager
  }
  
  //MARK: Formatter MB only
  static func MBFormatter(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = ByteCountFormatter.Units.useMB
    formatter.countStyle = ByteCountFormatter.CountStyle.decimal
    formatter.includesUnit = false
    return formatter.string(fromByteCount: bytes) as String
  }
  
  
  //MARK: Get String Value
  var totalDiskSpace: String {
    ByteCountFormatter.string(
      fromByteCount: totalDiskSpaceInBytes,
      countStyle: ByteCountFormatter.CountStyle.file
    )
  }
  
  var freeDiskSpace: String {
    ByteCountFormatter.string(
      fromByteCount: freeDiskSpaceInBytes,
      countStyle: ByteCountFormatter.CountStyle.file
    )
  }
  
  var usedDiskSpace:String {
    ByteCountFormatter.string(
      fromByteCount: usedDiskSpaceInBytes,
      countStyle: ByteCountFormatter.CountStyle.file
    )
  }
  
  
  //MARK: Get raw value
  var totalDiskSpaceInBytes: Int64 {
    do {
      let systemAttributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
      let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
      return space!
    } catch {
      return 0
    }
  }
  
  var freeDiskSpaceInBytes: Int64 {
    do {
      let systemAttributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
      let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
      return freeSpace!
    } catch {
      return 0
    }
  }
  
  var usedDiskSpaceInBytes: Int64 {
    totalDiskSpaceInBytes - freeDiskSpaceInBytes
  }
}
