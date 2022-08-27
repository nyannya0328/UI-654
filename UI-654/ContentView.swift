//
//  ContentView.swift
//  UI-654
//
//  Created by nyannyan0328 on 2022/08/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
