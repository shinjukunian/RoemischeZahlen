//
//  CameraConversionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/07.
//

import SwiftUI
import XLIICore

struct CameraConversionView: View {
    
    let input:Int
    let output:Output
    let original:String
    
    var body: some View {
        GroupBox(content: {
            HStack(alignment: .center){
                Text(original)
                let holder=NumeralConversionHolder(input: input, output: output, originalText: original)
                Text("↔︎").foregroundColor(.accentColor)
                Text(holder.formattedOutput)
            }.font(.title2)
        }, label: {
            VStack(alignment: .leading, spacing: 2.0){
                HStack{
                    Text(output.description)
                    
                }
                .font(.caption)
                Divider()
            }
        })
        .padding()
        .fixedSize(horizontal: true, vertical: true)
    }
}

struct CameraConversionView_Previews: PreviewProvider {
    static var previews: some View {
        CameraConversionView(input: 42, output: .japanisch, original: "42")
    }
}
