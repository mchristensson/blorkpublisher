//
//  ContentView.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = QueueHandlerViewModel(BlorkStorage.shared)
    
    
    var body: some View {
        QueueHandlerView(vm: vm)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


