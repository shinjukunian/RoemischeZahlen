//
//  OutputSelectionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import SwiftUI
import Algorithms

struct OutputSelectionView: View {
    
    struct OutputSelectionViewSection{
        let title:String
        let outputs:[Output]
        
        static let builtinTitle = NSLocalizedString("XLII", comment: "")
        static let systemTitle = NSLocalizedString("System", comment: "")
        static let numericTitle = NSLocalizedString("Numeric", comment: "")
    }
    
    @ObservedObject var holder:ConversionInputHolder
    @Environment(\.dismiss) var dismiss
    @Environment(\.isPresented) var isPresented
    
    @State var selection:Set<Output> = Set<Output>()
    
    @State var searchText:String = ""
    @State var displayInputs:[OutputSelectionViewSection] = [OutputSelectionViewSection]()
    
    init(holder:ConversionInputHolder){
        self.holder=holder
        self.selection=Set(holder.outputs)
    }
    
    
    
    
    var body: some View {
        
        
        List(selection: $selection){
            
            ForEach(displayInputs, id: \.outputs, content: {list in
                self.section(outPuts: list.outputs, title: list.title)
            })
            
        }
        .searchable(text: $searchText, placement: .automatic, prompt: Text("Search"))
        .onChange(of: selection, perform: {selection in
            holder.outputs=Array(selection)
        })
        

        .toolbar(content: {
            
            ToolbarItem(placement: .confirmationAction, content: {
                if isPresented{
                    Button(action: {
                        dismiss()
                    }, label: {Text("Done")})
                }
                else{
                    EmptyView()
                }
            })

        })
        .environment(\.editMode, .constant(.active))

        .onAppear(perform: {
            self.selection=Set(holder.outputs)
            self.displayInputs = [
                OutputSelectionViewSection(title: OutputSelectionViewSection.builtinTitle, outputs: Output.builtin),
                OutputSelectionViewSection(title: OutputSelectionViewSection.numericTitle, outputs: Output.numericTypes),
                OutputSelectionViewSection(title: OutputSelectionViewSection.systemTitle, outputs: Output.availableLocalizedOutputs)
                
            ]
        })
        .onSubmit(of: .search, {
            
        })
        .onChange(of: searchText, perform: {text in
            let availableSystem=Output.availableLocalizedOutputs.filter({$0.description.lowercased().hasPrefix(text.lowercased())})
            let availableBuiltin=Output.builtin.filter({$0.description.lowercased().hasPrefix(text.lowercased())})
            let availableNumeric=Output.numericTypes.filter({$0.description.lowercased().hasPrefix(text.lowercased())})
            
            self.displayInputs = [
                OutputSelectionViewSection(title: OutputSelectionViewSection.builtinTitle, outputs: availableBuiltin),
                OutputSelectionViewSection(title: OutputSelectionViewSection.numericTitle, outputs: availableNumeric),OutputSelectionViewSection(title: OutputSelectionViewSection.systemTitle, outputs: availableSystem)
                
            ].filter({$0.outputs.isEmpty == false})
        })
        
        
    }
    
    func section(outPuts:[Output], title:String)->some View{
        Section(content: {
            ForEach(outPuts, id: \.self, content: {output in
                HStack{
                    Text(output.description)
                    Spacer()
                    
                }.onDrag({
                    let provider=NSItemProvider(item: output.rawValue as NSString, typeIdentifier: Output.dragType)
                    return provider
                })
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
