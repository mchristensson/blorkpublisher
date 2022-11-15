//
//  BlorkStore.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation
import Combine

protocol BlorkStore {
    var allPublisher: AnyPublisher<[any BlorkItem], Never> { get }
    var incompletePublisher: AnyPublisher<[any BlorkItem], Never> { get }
    func setItems(_ items: [any BlorkItem],_ append: Bool)
    func update(_ item: any BlorkItem)
    func update(id: String?, _ state: BlorkState?, _ title: String?)
}
