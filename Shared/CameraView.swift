//
//  CameraView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import SwiftUI
import Combine

struct CameraView: View {
    
    @StateObject var recognizer=Recognizer()

    @State var sceneStabilityState:String = ""
    var cancelables=Set<AnyCancellable>()
    
    private var sceneStabilityPublisher:AnyPublisher<String,Never>{
        return recognizer.$state
            .receive(on: DispatchQueue.main)
            .map({$0.description})
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        VStack{
            Text(recognizer.state.description)
            PreviewHolder(recognizer: recognizer)
            .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
            
                
        }
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
