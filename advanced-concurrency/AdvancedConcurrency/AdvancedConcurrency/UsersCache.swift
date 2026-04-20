import Foundation

actor UsersCache {
	private var storage: [Int: User] = [:]
	private var inFlight: [Int: Task<User, Error>] = [:]
	private var accessLog: [String] = []
	
	func user(for id: Int) -> User? {
		let cached = storage[id]
		log(cached == nil ? "MISS for id = \(id)" : "HIT for id = \(id)")
		return cached
	}
	
	func save(_ user: User) {
		storage[user.id] = user
		log("SAVE id \(user.id)")
	}
	
	func task(for id: Int) -> Task<User, Error>? {
		let task = inFlight[id]
		log(task == nil ? "INFLIGHT MISS id = \(id)" : "INFLIGHT HIT id = \(id)")
		return task
	}
	
	func saveTask(_ task: Task<User, Error>, for id: Int) {
		inFlight[id] = task
		log("STORE TASK id=\(id)")
	}
	
	func removeTask(for id: Int) {
		inFlight[id] = nil
		log("REMOVE TASK id=\(id)")
	}
	
	func allUsers() -> [User] {
		storage.values.sorted {
			$0.id < $1.id
		}
	}
	
	func logs() -> [String] {
		accessLog
	}
	
	private func log(_ message: String) {
		let line = "[UsersCache] \(message)"
		accessLog.append(line)
		print(line)
	}
}
