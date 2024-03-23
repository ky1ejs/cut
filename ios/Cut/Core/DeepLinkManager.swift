//
//  DeepLinkManager.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import Foundation

class WeakSet<T>: Sequence {
    var count: Int {
        return weakStorage.count
    }

    typealias Element = T

    private let weakStorage = NSHashTable<AnyObject>.weakObjects()

    func add(_ object: T) {
        weakStorage.add(object as AnyObject)
    }

    func remove(_ object: T) {
        weakStorage.remove(object as AnyObject)
    }

    func removeAll() {
        weakStorage.removeAllObjects()
    }

    func contains(_ object: T) -> Bool {
        return weakStorage.contains(object as AnyObject)
    }

    func makeIterator() -> some IteratorProtocol<T> {
        (weakStorage.allObjects as! [T]).makeIterator()
    }
}

class DeepLinkManager {
    private var handlers = WeakSet<DeepLinkHandler>()
    static let shared = DeepLinkManager()

    var latestDeepLink: URL?

    func add(_ handler: DeepLinkHandler) {
        handlers.add(handler)
    }

    func remove(_ handler: DeepLinkHandler) {
        handlers.remove(handler)
    }

    @discardableResult
    func open(_ url: URL) -> Bool {
        for handler in handlers {
            for regex in handler.regexes {
                if let _ = try? regex.firstMatch(in: url.absoluteString) {
                    if handler.open(url) {
                        return true
                    }
                }
            }
        }
        return false
    }
}

protocol DeepLinkHandler: AnyObject {
    var id: String { get }
    var regexes: [Regex<Substring>] { get }
    func open(_ url: URL) -> Bool
}
