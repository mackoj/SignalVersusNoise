import Foundation
import Version

// MARK: - CrashModel
public struct CrashModel: Equatable, Codable {
  public var binaryImages: [BinaryImage]?
  public var crash: Crash?
  //  public var process: Process?
  public var report: Report?
  public var system: System?
  public var user: User?

  public init(
    binaryImages: [BinaryImage]?, crash: Crash? /*, process: Process?*/, report: Report?,
    system: System?, user: User?
  ) {
    self.binaryImages = binaryImages
    self.crash = crash
    //    self.process = process
    self.report = report
    self.system = system
    self.user = user
  }
}

// MARK: - BinaryImage
public struct BinaryImage: Equatable, Codable {
  public var cpuSubtype: Int?
  public var cpuType: Int?
  public var imageAddr: Int?
  public var imageSize: Int?
  public var name: String?
  public var uuid: String?

  public init(
    cpuSubtype: Int?, cpuType: Int?, imageAddr: Int?, imageSize: Int?, name: String?, uuid: String?
  ) {
    self.cpuSubtype = cpuSubtype
    self.cpuType = cpuType
    self.imageAddr = imageAddr
    self.imageSize = imageSize
    self.name = name
    self.uuid = uuid
  }
}

// MARK: - Crash
public struct Crash: Equatable, Codable {
  public var error: Error?
  public var threads: [Thread]?

  public init(error: Error?, threads: [Thread]?) {
    self.error = error
    self.threads = threads
  }
}

// MARK: - Error
public struct Error: Equatable, Codable {
  public var address: Int?
  public var mach: Mach?
  public var signal: Signal?
  public var type: String?

  public init(address: Int?, mach: Mach?, signal: Signal?, type: String?) {
    self.address = address
    self.mach = mach
    self.signal = signal
    self.type = type
  }
}

// MARK: - Mach
public struct Mach: Equatable, Codable {
  public var code: Int?
  public var exception: Int?
  public var exceptionName: String?
  public var subcode: Int?

  public init(code: Int?, exception: Int?, exceptionName: String?, subcode: Int?) {
    self.code = code
    self.exception = exception
    self.exceptionName = exceptionName
    self.subcode = subcode
  }
}

// MARK: - Signal
public struct Signal: Equatable, Codable {
  public var code: Int?
  public var name: String?
  public var signal: Int?

  public init(code: Int?, name: String?, signal: Int?) {
    self.code = code
    self.name = name
    self.signal = signal
  }
}

// MARK: - Thread
public struct Thread: Equatable, Codable {
  public var backtrace: Backtrace?
  public var crashed: Bool?
  public var currentThread: Bool?
  public var dispatchQueue: String?
  public var index: Int?
  //    public var notableAddresses: NotableAddresses?
  public var registers: Registers?
  public var stack: Stack?
  public var name: String?

  public init(
    backtrace: Backtrace?, crashed: Bool?, currentThread: Bool?, dispatchQueue: String?,
    index: Int? /*, notableAddresses: NotableAddresses?*/, registers: Registers?, stack: Stack?,
    name: String?
  ) {
    self.backtrace = backtrace
    self.crashed = crashed
    self.currentThread = currentThread
    self.dispatchQueue = dispatchQueue
    self.index = index
    //        self.notableAddresses = notableAddresses
    self.registers = registers
    self.stack = stack
    self.name = name
  }
}

// MARK: - Backtrace
public struct Backtrace: Equatable, Codable {
  public var contents: [Content]?
  public var skipped: Int?

  public init(contents: [Content]?, skipped: Int?) {
    self.contents = contents
    self.skipped = skipped
  }
}

// MARK: - Content
public struct Content: Equatable, Codable {
  public var instructionAddr: Int?
  public var objectAddr: Int?
  public var objectName: String?
  public var symbolAddr: Int?
  public var symbolName: String?

  public init(
    instructionAddr: Int?, objectAddr: Int?, objectName: String?, symbolAddr: Int?,
    symbolName: String?
  ) {
    self.instructionAddr = instructionAddr
    self.objectAddr = objectAddr
    self.objectName = objectName
    self.symbolAddr = symbolAddr
    self.symbolName = symbolName
  }
}

//// MARK: - NotableAddresses
//public struct NotableAddresses: Equatable, Codable {
//    public var r4: R4?
//    public var stack0X2Fe5C7F8: R4?
//    public var stack0X2Fe5C7Fc: Stack0_X2Fe5C7Fc?
//    public var stack0X2Fe5C810: Stack0_X2Fe5C7Fc?
//    public var stack0X2Fe5C814: Stack0_X2Fe5C7Fc?
//
//    public init(r4: R4?, stack0X2Fe5C7F8: R4?, stack0X2Fe5C7Fc: Stack0_X2Fe5C7Fc?, stack0X2Fe5C810: Stack0_X2Fe5C7Fc?, stack0X2Fe5C814: Stack0_X2Fe5C7Fc?) {
//        self.r4 = r4
//        self.stack0X2Fe5C7F8 = stack0X2Fe5C7F8
//        self.stack0X2Fe5C7Fc = stack0X2Fe5C7Fc
//        self.stack0X2Fe5C810 = stack0X2Fe5C810
//        self.stack0X2Fe5C814 = stack0X2Fe5C814
//    }
//}

// MARK: - R4
public struct R4: Equatable, Codable {
  public var address: Int?
  public var type: String?
  public var value: String?

  public init(address: Int?, type: String?, value: String?) {
    self.address = address
    self.type = type
    self.value = value
  }
}

// MARK: - FirstObjectIvars
public struct FirstObjectIvars: Equatable, Codable {
  public var accessoryType: Int?
  //    public var block: Stack0_X2Fe5C7Fc?
  public var name: Commands?

  public init(accessoryType: Int? /*, block: Stack0_X2Fe5C7Fc?*/, name: Commands?) {
    self.accessoryType = accessoryType
    //        self.block = block
    self.name = name
  }
}

// MARK: - FirstObject
public struct FirstObject: Equatable, Codable {
  public var address: Int?
  public var firstObjectClass: String?
  public var ivars: FirstObjectIvars?
  public var lastDeallocatedObj: String?
  public var type: String?

  public init(
    address: Int?, firstObjectClass: String?, ivars: FirstObjectIvars?, lastDeallocatedObj: String?,
    type: String?
  ) {
    self.address = address
    self.firstObjectClass = firstObjectClass
    self.ivars = ivars
    self.lastDeallocatedObj = lastDeallocatedObj
    self.type = type
  }
}

// MARK: - Commands
public class Commands: Equatable, Codable {
  public static func == (lhs: Commands, rhs: Commands) -> Bool {
    return lhs.address == rhs.address && lhs.commandsClass == rhs.commandsClass
      && lhs.type == rhs.type && lhs.firstObject == rhs.firstObject
  }

  public var address: Int?
  public var commandsClass: String?
  //  public var ivars: Process?
  public var type: String?
  public var firstObject: FirstObject?

  public init(
    address: Int?, commandsClass: String? /*, ivars: Process?*/, type: String?,
    firstObject: FirstObject?
  ) {
    self.address = address
    self.commandsClass = commandsClass
    //    self.ivars = ivars
    self.type = type
    self.firstObject = firstObject
  }
}

//// MARK: - Stack0X2Fe5C7FcIvars
//public struct Stack0X2Fe5C7FcIvars: Equatable, Codable {
//    public var lock: Commands?
//    public var commands: Commands?
//    public var getTitleBlock: GetTitleBlock?
//
//    public init(lock: Commands?, commands: Commands?, getTitleBlock: GetTitleBlock?) {
//        self.lock = lock
//        self.commands = commands
//        self.getTitleBlock = getTitleBlock
//    }
//}

//// MARK: - Stack0_X2Fe5C7Fc
//public class Stack0_X2Fe5C7Fc: Equatable, Codable {
//    public var address: Int?
//    public var stack0_X2Fe5C7FcClass: String?
//    public var ivars: Stack0X2Fe5C7FcIvars?
//    public var type: String?
//    public var lastDeallocatedObj: String?
//
//    public init(address: Int?, stack0_X2Fe5C7FcClass: String?, ivars: Stack0X2Fe5C7FcIvars?, type: String?, lastDeallocatedObj: String?) {
//        self.address = address
//        self.stack0_X2Fe5C7FcClass = stack0_X2Fe5C7FcClass
//        self.ivars = ivars
//        self.type = type
//        self.lastDeallocatedObj = lastDeallocatedObj
//    }
//}

//// MARK: - Process
//public struct Process: Equatable, Codable {
//
//  public init() {
//  }
//}

// MARK: - GetTitleBlock
public struct GetTitleBlock: Equatable, Codable {
  public var address: Int?
  public var type: String?

  public init(address: Int?, type: String?) {
    self.address = address
    self.type = type
  }
}

// MARK: - Registers
public struct Registers: Equatable, Codable {
  public var basic: Basic?
  public var exception: Exception?

  public init(basic: Basic?, exception: Exception?) {
    self.basic = basic
    self.exception = exception
  }
}

// MARK: - Basic
public struct Basic: Equatable, Codable {
  public var cpsr: Int?
  public var ip: Int?
  public var lr: Int?
  public var pc: Int?
  public var r0: Int?
  public var r1: Int?
  public var r10: Int?
  public var r11: Int?
  public var r2: Int?
  public var r3: Int?
  public var r4: Int?
  public var r5: Int?
  public var r6: Int?
  public var r7: Int?
  public var r8: Int?
  public var r9: Int?
  public var sp: Int?

  public init(
    cpsr: Int?, ip: Int?, lr: Int?, pc: Int?, r0: Int?, r1: Int?, r10: Int?, r11: Int?, r2: Int?,
    r3: Int?, r4: Int?, r5: Int?, r6: Int?, r7: Int?, r8: Int?, r9: Int?, sp: Int?
  ) {
    self.cpsr = cpsr
    self.ip = ip
    self.lr = lr
    self.pc = pc
    self.r0 = r0
    self.r1 = r1
    self.r10 = r10
    self.r11 = r11
    self.r2 = r2
    self.r3 = r3
    self.r4 = r4
    self.r5 = r5
    self.r6 = r6
    self.r7 = r7
    self.r8 = r8
    self.r9 = r9
    self.sp = sp
  }
}

// MARK: - Exception
public struct Exception: Equatable, Codable {
  public var exception: Int?
  public var far: Int?
  public var fsr: Int?

  public init(exception: Int?, far: Int?, fsr: Int?) {
    self.exception = exception
    self.far = far
    self.fsr = fsr
  }
}

// MARK: - Stack
public struct Stack: Equatable, Codable {
  public var contents: String?
  public var dumpEnd: Int?
  public var dumpStart: Int?
  public var growDirection: String?
  public var overflow: Bool?
  public var stackPointer: Int?

  public init(
    contents: String?, dumpEnd: Int?, dumpStart: Int?, growDirection: String?, overflow: Bool?,
    stackPointer: Int?
  ) {
    self.contents = contents
    self.dumpEnd = dumpEnd
    self.dumpStart = dumpStart
    self.growDirection = growDirection
    self.overflow = overflow
    self.stackPointer = stackPointer
  }
}

// MARK: - Report
public struct Report: Equatable, Codable {
  public var id: String?
  public var processName: String?
  public var timestamp: String?
  public var type: String?
  public var version: Version?

  public init(
    id: String?, processName: String?, timestamp: String?, type: String?, version: Version?
  ) {
    self.id = id
    self.processName = processName
    self.timestamp = timestamp
    self.type = type
    self.version = version
  }
}

//// MARK: - Version
//public struct Version: Equatable, Codable {
//  public var major: Int?
//  public var minor: Int?
//
//  public init(major: Int?, minor: Int?) {
//    self.major = major
//    self.minor = minor
//  }
//}

// MARK: - System
public struct System: Equatable, Codable {
  public var cfBundleExecutable: String?
  public var cfBundleExecutablePath: String?
  public var cfBundleIdentifier: String?
  public var cfBundleName: String?
  public var cfBundleShortVersionString: String?
  public var cfBundleVersion: String?
  public var appStartTime: String?
  public var appuuid: String?
  public var applicationStats: ApplicationStats?
  public var bootTime: String?
  public var cpuArch: String?
  public var deviceAppHash: String?
  public var jailbroken: Bool?
  public var kernelVersion: String?
  public var machine: String?
  public var memory: Memory?
  public var model: String?
  public var osVersion: String?
  public var parentProcessid: Int?
  public var parentProcessName: String?
  public var processid: Int?
  public var processName: String?
  public var systemName: String?
  public var systemVersion: String?
  public var timeZone: String?

  public init(
    cfBundleExecutable: String?, cfBundleExecutablePath: String?, cfBundleIdentifier: String?,
    cfBundleName: String?, cfBundleShortVersionString: String?, cfBundleVersion: String?,
    appStartTime: String?, appuuid: String?, applicationStats: ApplicationStats?, bootTime: String?,
    cpuArch: String?, deviceAppHash: String?, jailbroken: Bool?, kernelVersion: String?,
    machine: String?, memory: Memory?, model: String?, osVersion: String?, parentProcessid: Int?,
    parentProcessName: String?, processid: Int?, processName: String?, systemName: String?,
    systemVersion: String?, timeZone: String?
  ) {
    self.cfBundleExecutable = cfBundleExecutable
    self.cfBundleExecutablePath = cfBundleExecutablePath
    self.cfBundleIdentifier = cfBundleIdentifier
    self.cfBundleName = cfBundleName
    self.cfBundleShortVersionString = cfBundleShortVersionString
    self.cfBundleVersion = cfBundleVersion
    self.appStartTime = appStartTime
    self.appuuid = appuuid
    self.applicationStats = applicationStats
    self.bootTime = bootTime
    self.cpuArch = cpuArch
    self.deviceAppHash = deviceAppHash
    self.jailbroken = jailbroken
    self.kernelVersion = kernelVersion
    self.machine = machine
    self.memory = memory
    self.model = model
    self.osVersion = osVersion
    self.parentProcessid = parentProcessid
    self.parentProcessName = parentProcessName
    self.processid = processid
    self.processName = processName
    self.systemName = systemName
    self.systemVersion = systemVersion
    self.timeZone = timeZone
  }
}

// MARK: - ApplicationStats
public struct ApplicationStats: Equatable, Codable {
  public var activeTimeSinceLastCrash: Double?
  public var activeTimeSinceLaunch: Double?
  public var applicationActive: Bool?
  public var applicationInForeground: Bool?
  public var backgroundTimeSinceLastCrash: Int?
  public var backgroundTimeSinceLaunch: Int?
  public var launchesSinceLastCrash: Int?
  public var sessionsSinceLastCrash: Int?
  public var sessionsSinceLaunch: Int?

  public init(
    activeTimeSinceLastCrash: Double?, activeTimeSinceLaunch: Double?, applicationActive: Bool?,
    applicationInForeground: Bool?, backgroundTimeSinceLastCrash: Int?,
    backgroundTimeSinceLaunch: Int?, launchesSinceLastCrash: Int?, sessionsSinceLastCrash: Int?,
    sessionsSinceLaunch: Int?
  ) {
    self.activeTimeSinceLastCrash = activeTimeSinceLastCrash
    self.activeTimeSinceLaunch = activeTimeSinceLaunch
    self.applicationActive = applicationActive
    self.applicationInForeground = applicationInForeground
    self.backgroundTimeSinceLastCrash = backgroundTimeSinceLastCrash
    self.backgroundTimeSinceLaunch = backgroundTimeSinceLaunch
    self.launchesSinceLastCrash = launchesSinceLastCrash
    self.sessionsSinceLastCrash = sessionsSinceLastCrash
    self.sessionsSinceLaunch = sessionsSinceLaunch
  }
}

// MARK: - Memory
public struct Memory: Equatable, Codable {
  public var free: Int?
  public var size: Int?
  public var usable: Int?

  public init(free: Int?, size: Int?, usable: Int?) {
    self.free = free
    self.size = size
    self.usable = usable
  }
}

// MARK: - User
public struct User: Equatable, Codable {
  public var quotedKey: String?
  public var bslashValue: String?
  public var bslashKey: String?
  public var intl2: String?
  public var quotedValue: String?
  public var test: String?
  //  public var テスト: String?

  public init(
    quotedKey: String?, bslashValue: String?, bslashKey: String?, intl2: String?,
    quotedValue: String?, test: String? /*, テスト: String?*/
  ) {
    self.quotedKey = quotedKey
    self.bslashValue = bslashValue
    self.bslashKey = bslashKey
    self.intl2 = intl2
    self.quotedValue = quotedValue
    self.test = test
    //    self.テスト = テスト
  }
}
