import Foundation

actor AsyncSemaphore {
	private let limit: Int
	private var count = 0
	private var waiters: [CheckedContinuation<Void, Never>] = []
	
	init (limit: Int) {
		self.limit = max(1, limit)
	}
	
	func acquire() async {
		if count < limit {
			count += 1
			return
		}
		
		await withCheckedContinuation { continuation in
			waiters.append(continuation)
		}
	}
	
	func release() {
		if !waiters.isEmpty {
			let waiter = waiters.removeFirst()
			waiter.resume()
		} else {
			count = max(0, count - 1)
		}
	}
}
