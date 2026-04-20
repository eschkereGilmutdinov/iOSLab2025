import Foundation

protocol UsersRepositoryProtocol: Sendable {
	func user(id: Int) async throws -> User
	func users(ids: [Int]) async throws -> [User]
	func cachedUsers() async -> [User]
	func cacheLogs() async -> [String]
}

final class UsersRepository: UsersRepositoryProtocol, @unchecked Sendable {
	private let api: UsersAPIClientProtocol
	private let cache: UsersCache
	private let semaphore: AsyncSemaphore

	init(
		api: UsersAPIClientProtocol = UsersAPIClient(),
		cache: UsersCache = UsersCache(),
		maxConcurrentRequests: Int = 3
	) {
		self.api = api
		self.cache = cache
		self.semaphore = AsyncSemaphore(limit: maxConcurrentRequests)
	}

	func user(id: Int) async throws -> User {
		try Task.checkCancellation()

		if let cached = await cache.user(for: id) {
			return cached
		}

		if let existingTask = await cache.task(for: id) {
			return try await existingTask.value
		}

		let task = Task<User, Error> {
			try Task.checkCancellation()

			await semaphore.acquire()
			defer {
				Task {
					await semaphore.release()
				}
			}

			let user = try await api.fetchUser(id: id)
			await cache.save(user)
			return user
		}

		await cache.saveTask(task, for: id)

		do {
			let result = try await task.value
			await cache.removeTask(for: id)
			return result
		} catch {
			task.cancel()
			await cache.removeTask(for: id)
			throw error
		}
	}

	func users(ids: [Int]) async throws -> [User] {
		try Task.checkCancellation()

		return try await withThrowingTaskGroup(of: User.self) { group in
			for id in ids {
				group.addTask { [weak self] in
					guard let self else { throw CancellationError() }
					return try await self.user(id: id)
				}
			}

			var users: [User] = []

			for try await user in group {
				users.append(user)
			}

			return users.sorted { $0.id < $1.id }
		}
	}

	func cachedUsers() async -> [User] {
		await cache.allUsers()
	}

	func cacheLogs() async -> [String] {
		await cache.logs()
	}
}
