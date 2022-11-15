//
//  BlorkStorage.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation
import Combine
import CoreData

/// MARK : Storage-definition of some container that stores entities of the Blork-type
class BlorkStorage: NSObject, BlorkStore {
    
    static let shared: BlorkStore = BlorkStorage()
    
    var allPublisher: AnyPublisher<[BlorkItem], Never> {
        self.allSubject.eraseToAnyPublisher()
    }
    var incompletePublisher: AnyPublisher<[BlorkItem], Never> {
        self.allIncompleteSubject.eraseToAnyPublisher()
    }
    
    private var allSubject = CurrentValueSubject<[BlorkItem], Never>([])
    private var allIncompleteSubject = CurrentValueSubject<[BlorkItem], Never>([])
    
    public func setItems(_ items: [BlorkItem],_ append: Bool = false) {
        
       
        if (append) {
            self.allSubject.value.append(contentsOf: items)
            
            let filteredItems = items.filter {[.PENDING, .IN_PROGRESS].contains($0.state)}
            let firstHalfEndIndex = filteredItems.count > 1 ? filteredItems.count / 2 : filteredItems.count
            self.allIncompleteSubject.value.append(contentsOf: Array(filteredItems[..<firstHalfEndIndex]))
            
        } else {
            self.allSubject.send(items)
            
            let filteredItems = items.filter {[.PENDING, .IN_PROGRESS].contains($0.state)}
            let firstHalfEndIndex = filteredItems.count > 1 ? filteredItems.count / 2 : filteredItems.count
            self.allIncompleteSubject.send(Array(filteredItems[..<firstHalfEndIndex]))
        }
        
    }
    
    public func update(_ item: BlorkItem) {
        let currentItems: [BlorkItem] = self.allSubject.value.map { existing in
            if existing.isSame(as: item) {
                return Blork.copy(of: existing)
            }
            return existing
        }
        setItems(currentItems)
    }
    
    public func update(id: String?,_ state: BlorkState? = nil,_ title: String? = nil) {
        guard let refId = id else {
            return
        }
        
        let currentItems: [BlorkItem] = self.allSubject.value.compactMap { existing in
            guard let existingId = existing.id else {
                return existing
            }
            if existingId.elementsEqual(refId) {
                return Blork.copy(of: existing, withState: state, withTitle: title)
            }
            return existing
        }
        setItems(currentItems)
    }
    
}
