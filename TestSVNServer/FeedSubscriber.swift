import Foundation
import AnyCodable
import SharedCode
import Combine

class FeedSubscriber: Subscriber {
    typealias Input = Event<AnyCodable>
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Event<AnyCodable>) -> Subscribers.Demand {
        print("Received: \(input)")
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completion event:", completion)
    }
}
