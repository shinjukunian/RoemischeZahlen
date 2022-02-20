//
//  OutputSelectionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import SwiftUI
import Algorithms

struct OutputSelectionView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    @Environment(\.dismiss) var dismiss

    @State var selection:Set<Output> = Set<Output>()
    
    init(holder:ConversionInputHolder){
        self.holder=holder
        self.selection=Set(holder.outputs)
    }
    
    var availableBuiltinOutputs:[Output]  {
        return [.römisch,.japanisch,.japanisch_bank, .babylonian]
    }
    
    var availableLocalizedOutputs:[Output]{
        let current=Locale.current
        return Locale.availableIdentifiers
            .filter({$0 != "ja_JP"})
            .map({Locale(identifier: $0)})
            .uniqued(on: {$0.languageCode ?? ""})
            .sorted(by: {l1,l2 in
                guard let language1=current.localizedString(forLanguageCode: l1.languageCode ?? ""),
                      let language2=current.localizedString(forLanguageCode: l2.languageCode ?? "")
                else{
                    return true
                }
                return language1 < language2
                
            })
            .map({Output.localized(locale: $0)})
        
    }
    
    var body: some View {
        
        NavigationView{
            List(selection: $selection){
                
                self.section(outPuts: availableBuiltinOutputs, title: NSLocalizedString("XLII", comment: ""))
                
                self.section(outPuts: availableLocalizedOutputs, title: NSLocalizedString("System", comment: ""))
               
            }
            
            .navigationTitle(Text("Output Selection"))
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(action: {
                        holder.outputs=Array(selection)
                        dismiss()
                    }, label: {Text("Done")})
                })
            })
            #if os(iOS)
            .environment(\.editMode, .constant(.active))
            #endif
            .onAppear(perform: {
                self.selection=Set(holder.outputs)
            })
        }
        
    }
    
    func section(outPuts:[Output], title:String)->some View{
        Section(content: {
            ForEach(outPuts, id: \.self, content: {output in
                HStack{
                    Text(output.description)
                    Spacer()
                    
                }
            })
            
        }, header: {
            Text(title)
        })
    }
}

struct OutputSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        OutputSelectionView(holder: ConversionInputHolder())
    }
}
