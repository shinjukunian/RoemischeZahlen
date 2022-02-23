//
//  OutputSelectionView.swift
//  XLII (macOS)
//
//  Created by Morten Bertz on 2022/02/22.
//

import SwiftUI

struct OutputSelectionView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    
    @State var searchText:String = ""
    
    @State var outputs:[Output] = [Output]()
    @State var showSelected:Bool = false
    var availableOutputs:[Output]{
        Output.builtin + Output.numericTypes + Output.availableLocalizedOutputs
    }
    
    @Environment(\.undoManager) var undoManager
    
    @State private var sortOrder = [
        KeyPathComparator(\Output.description, comparator: .localizedStandard, order: .forward)
    ]

    var body: some View {
        
        VStack(spacing:0){
            tableView
            HStack(alignment: .center){
                Spacer()
                Button(action: {
                    let selected=holder.outputs
                    undoManager?.registerUndo(withTarget: holder, handler: {holder in
                        holder.outputs=selected
                    })
                    
                    holder.outputs.removeAll()
                }, label: {
                    Text("Deselect All")
                })
                Spacer()
                Toggle(isOn: $showSelected, label: {
                    Text("Show Selected")
                }).toggleStyle(.button)
                Spacer()
                
            }.controlSize(.mini)
            .padding(.vertical, 6.0)
                .onChange(of: showSelected, perform: {showSelected in
                    if showSelected{
                        outputs=availableOutputs.filter({holder.outputs.contains($0)})
                    }
                    else{
                        outputs=availableOutputs
                    }
                })
                
        }
    }
    
    
    var tableView: some View{
        Table(sortOrder: $sortOrder, columns: {
                        
            TableColumn("Selected", content: {output in
                
                let binding=Binding<Bool>(get: {
                    holder.outputs.contains(output)
                }, set: {value, transaction in
                    if value == true{
                        holder.outputs.append(output)
                    }
                    else if let pos=holder.outputs.firstIndex(of: output){
                        holder.outputs.remove(at: pos)
                    }
                })
                
                Toggle(isOn: binding, label: {})
            }).width(min: 50, ideal: 50, max: 60)
            

            TableColumn("Name", value: \.description)
        }, rows: {
            ForEach(outputs, id: \.id, content: {output in
                TableRow(output)
                    .itemProvider({
                    let itemProvider=NSItemProvider(item: output.rawValue as NSString, typeIdentifier: Output.dragType)
                    return itemProvider
                })
            })
        })
            
        .tableStyle(.inset(alternatesRowBackgrounds: true))
        .onAppear{
            outputs=Output.builtin + Output.numericTypes + Output.availableLocalizedOutputs
        }
        .searchable(text: $searchText, placement: .automatic, prompt: Text("Search"))
        .onChange(of: searchText, perform: {text in
    
            if text.isEmpty{
                outputs=availableOutputs
            }
            else{
                let filtered=availableOutputs.filter({$0.description.localizedStandardContains(text.trimmingCharacters(in: .whitespaces))
                    
                })
                outputs=filtered
            }
            
        })
        .onChange(of: sortOrder, perform: {sortOrder in
            outputs.sort(using: sortOrder)
        })
    }
    
}

struct OutputSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        OutputSelectionView(holder:ConversionInputHolder())
    }
}
