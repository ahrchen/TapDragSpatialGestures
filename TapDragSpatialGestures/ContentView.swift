//
//  ContentView.swift
//  TapDragSpatialGestures
//
//  Created by Raymond Chen on 3/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false
    @State var color: SimpleMaterial.Color = SimpleMaterial.Color.red
    
    private let colors: [SimpleMaterial.Color] = [.red, .green, .blue, .systemBrown, .systemPurple, .systemMint]
    static var cubeEntity = Entity()
    
    var body: some View {
        VStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let cube = try? await Entity(named: "Cube", in: realityKitContentBundle) {
                    ContentView.cubeEntity = cube
                    content.add(cube)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                ContentView.cubeEntity.components[ModelComponent.self] = ModelComponent(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: color, isMetallic: false)])
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ _ in
                        color = colors.randomElement()!
                    })
            )
            .gesture(
                DragGesture()
                    .targetedToEntity(ContentView.cubeEntity)
                    .onChanged({ value in
                        ContentView.cubeEntity.position = value.convert(value.location3D, from: .local, to: ContentView.cubeEntity.parent!)
                    })
            )
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
