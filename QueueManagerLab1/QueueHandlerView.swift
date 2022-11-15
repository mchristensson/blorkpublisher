//
//  QueueHandlerView.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import SwiftUI
import OSLog
import Combine

struct QueueHandlerView: View {
    
    @ObservedObject var vm: QueueHandlerViewModel
    
    var body: some View {
        VStack {
            Text("Blorks").font(.title)
            Text("\(vm.progress)").font(.subheadline)
            List {
                ForEach(vm.items, id: \.self) { item in
                    Text("hello \(item)")
                }
            }.border(.gray, width: 1)
            
            HStack {
                
                
                //Button to append 4 new
                Button {
                    vm.setItems(4, append: true)
                } label: {
                    Label("Append 4", systemImage: "plus.circle")
                }.buttonStyle(.borderedProminent)

                
                //Button to clear and set 4 new
                Button {
                    vm.setItems(4, append: false)
                } label: {
                    Label("Set to 4", systemImage: "plus.circle")
                }.buttonStyle(.borderedProminent)
                
                
            }
            
        }.padding(20)
        
    }
}

struct QueueHandlerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = QueueHandlerViewModel(BlorkStorage.shared)
        QueueHandlerView(vm: vm)
    }
}

