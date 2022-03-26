//
//  CameraControllsView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/05.
//

import SwiftUI
import XLIICore

struct CameraControllsView: View {
    
    @Binding var useROI:Bool
    @Binding var convert:Bool
    @Binding var outputType:Output
    
    @AppStorage(UserDefaults.Keys.preferredBasesKey) var preferredBases:BasePreference = BasePreference.default
    
    let onDismissPressed:(()->Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12){
            VStack{
                Toggle(isOn: $convert){
                    Text("Convert")
                }.fixedSize()

                Toggle(isOn: $useROI){
                    Text("Use ROI")
                }.fixedSize()
            }
            
            Picker(selection: $outputType, label: Text("Output"), content: {
                ForEach(Output.builtin + preferredBases.outputs, id: \.self, content: {output in
                    Text(verbatim: output.description)
                        .lineLimit(3)
                        .tag(output)
                })
            })
            .pickerStyle(.menu)
            .disabled(convert == false)
            .fixedSize(horizontal: true, vertical: true)
            Spacer()

            Button(role: .cancel, action: {
                onDismissPressed()
            }, label: {
                Text("Dismis")
            }).buttonStyle(.bordered)


        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.ultraThinMaterial)
    }
}

struct CameraControllsView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControllsView(useROI: .constant(true), convert: .constant(true), outputType: .constant(.japanisch), onDismissPressed: {})
    }
}
