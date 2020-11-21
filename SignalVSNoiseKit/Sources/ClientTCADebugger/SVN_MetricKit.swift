#if canImport(MetricKit)
import Foundation
import MetricKit

extension SVNClientTransceiver {
    func registerMetricKit() {
        
    }
}
#else
extension SVNClientTransceiver {
    func registerMetricKit() {}
}
#endif
