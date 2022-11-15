//
//  BlorkItem.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation

public protocol BlorkItem {
    var title: String? { get set }
    var id: String? { get set }
    var state: BlorkState { get set }
}

extension BlorkItem {
    
    public func isSame(as new: BlorkItem) -> Bool {
        guard let originalId = self.id else  {
            return false
        }
        guard let newId = new.id else  {
            return false
        }
        return !originalId.elementsEqual(newId)
    }

}

public enum BlorkState {
    case PENDING
    case IN_PROGRESS
    case DONE
}
