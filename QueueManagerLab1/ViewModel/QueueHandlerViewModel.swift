//
//  QueueHandlerViewModel.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation
import Combine
import OSLog

class QueueHandlerViewModel: ObservableObject {
    
    @Published var foo: String = "hello"
    @Published private(set) var items: [String] = []
    @Published var progress: String = ""
    
    private var blorkItemsSubscription: Cancellable?
    private var blorkItemsProcessSubscription: Cancellable?
    private var subscriptions: Set<AnyCancellable> = []
    private var storage: BlorkStore
    
    private var queue: OperationQueue
    private var queueIndex: [String:String] = [:]
     
    init(_ storage: BlorkStore = BlorkStorage.shared) {
        self.storage = storage
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
        self.queue.progress.becomeCurrent(withPendingUnitCount: 0)
        
        //Subscribe on queue-progress
        Publishers.CombineLatest(
            self.queue.progress.publisher(for: \.self.completedUnitCount),
            self.queue.progress.publisher(for: \.self.totalUnitCount))
        .eraseToAnyPublisher()
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .sink { a,b in
            self.progress = "Progress: \(String(describing: b)) / of \(String(describing: a))"
        }.store(in: &subscriptions)

        //Lista alla objekt i GUI
        blorkItemsSubscription = storage.allPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] blorkItems in
                guard let self = self else {return}
            self.items = blorkItems.map { item in
                "\(item.title ?? "unnamed") \(String(describing: item.state))"
            }
        }
        
        // Hämta objekt som ska bearbetas
        blorkItemsProcessSubscription = storage.incompletePublisher
            .subscribe(on: DispatchQueue.global())
            .debounce(for: 3.0, scheduler: DispatchQueue.global())
            .sink { [weak self] incompletedblorkItems in
                guard let self = self else {return}
                
                
                let allOperations = incompletedblorkItems.filter({ item in
                    guard let id = item.id else {
                        return false
                    }
                    let alreadyPresent = self.queueIndex.contains(where: { (key: String, value: String) in
                        key.elementsEqual(id)
                    })
                    print("Finns \(id) redan i index? \(alreadyPresent)")
                    return !alreadyPresent
                }).compactMap { blorkItem in
                    FooOperation(itemId: blorkItem.id!, onCompleteHandler: {
                        print("onCompleteHandler: I'm done!")
                         storage.update(id: blorkItem.id, .DONE, nil)
                         self.queue.progress.completedUnitCount = self.queue.progress.completedUnitCount + 1
                        if let id = blorkItem.id {
                            self.queueIndex.removeValue(forKey: id)
                        }
                        
                    })
                }
                
                
                
               // self.queue.progress.resume()
                
                allOperations.forEach { blorkOperation in
                    print("lägger till blorkOperationid i INDEX \(String(describing: blorkOperation.id))")
                    self.queueIndex[blorkOperation.id] = ""
                }
                print("INDEX \(String(describing: self.queueIndex))")
                self.queue.progress.totalUnitCount = self.queue.progress.totalUnitCount + Int64(allOperations.count)
                self.queue.addOperations(allOperations, waitUntilFinished: true)
                
                
                print("Operations added.")
        }
         
    }
    
    func setItems(_ numberOfItems: Int = 1, append: Bool) {
        Logger.general.info("Adding \(numberOfItems) elements...")
        let blorkItems : [Blork] = Array(repeating: "Boooh!", count: numberOfItems).map { title in
            let item = Blork()
            item.title = title
            return item
        }
        storage.setItems(blorkItems, append)
    }
    
    
}


class FooOperation: Operation, Identifiable {

    let id: String
    private let onCompleteHandler: () -> Void
    
    init(itemId: String, onCompleteHandler: @escaping () -> Void) {
        self.onCompleteHandler = onCompleteHandler
        self.id = itemId
    }
    
    override func main() {
        //Logger.general.info("Processing queue-entry...")
        onCompleteHandler()
    }
}
