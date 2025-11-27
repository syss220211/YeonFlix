//
//  PresentationExample.swift
//  Manifests
//
//  Created by 박서연 on 7/18/25.
//

// PresentationExample
import SwiftUI

public struct MyLibraryView: View {
    
    public var body: some View {
        Text("Hello from Static Library!")
            .font(.largeTitle)
    }
}

#Preview {
    MyLibraryView()
}
