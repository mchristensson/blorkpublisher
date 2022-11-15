//
//  Blork.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation

/// MARK: Model description for the Blork-type
@objc(Blork)
public class Blork: NSObject {
    
    /*
     @NSManaged property removed
     */
    public var title: String?
    public var id: String?
    public var state: BlorkState
    
    public override init() {
        self.state = .PENDING
        super.init()
        self.id = UUID().uuidString
    }
    
    public func isSame(as new: Blork) -> Bool {
        guard let originalId = self.id else  {
            return false
        }
        guard let newId = new.id else  {
            return false
        }
        return !originalId.elementsEqual(newId)
    }
    
    public static func copy(of: BlorkItem, withState state: BlorkState? = nil, withTitle title: String? = nil) -> BlorkItem {
        let a = Blork()
        if let t = title {
            a.title = t
        }
        if let s = state {
            a.state = s
        }
        return a
    }
}

extension Blork : Identifiable, BlorkItem {
    
    
}
