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
    
    var availableLocalizedOutputs:[Output]{
        let current=Locale.current
        return Locale.availableIdentifiers
            .filter({$0.hasPrefix("ja") == false })
            .map({Locale(identifier: $0)})
            .filter({$0.languageCode != nil || $0 != current})
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
        
        
        List(selection: $selection){
            
            ForEach(displayInputs, id: \.outputs, content: {list in
                self.section(outPuts: list.outputs, title: list.title)
            })
            
        }
        .searchable(text: $searchText, placement: .automatic, prompt: Text("Search"))
        
        
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
        .onChange(of: selection, perform: {selection in
            holder.outputs=Array(selection)
        })
        .background(.thinMaterial)
#if os(iOS)
        .environment(\.editMode, .constant(.active))
#endif
        .onAppear(perform: {
            self.selection=Set(holder.outputs)
            self.displayInputs = [
                OutputSelectionViewSection(title: OutputSelectionViewSection.builtinTitle, outputs: Output.builtin),
                OutputSelectionViewSection(title: OutputSelectionViewSection.numericTitle, outputs: Output.numericTypes),
                OutputSelectionViewSection(title: OutputSelectionViewSection.systemTitle, outputs: availableLocalizedOutputs)
                
            ]
        })
        .onSubmit(of: .search, {
            
        })
        .onChange(of: searchText, perform: {text in
            let availableSystem=availableLocalizedOutputs.filter({$0.description.lowercased().hasPrefix(text.lowercased())})
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
