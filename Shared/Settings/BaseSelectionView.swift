//
//  BaseSelectionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/23.
//

import SwiftUI
import XLIICore

struct BaseSelectionView: View {
    
    @AppStorage(UserDefaults.Keys.preferredBasesKey) var preferredBases:BasePreference = .default
    @AppStorage(UserDefaults.Keys.outPutModesKey) var outputPreference: OutputPreference = .default

    @State var actions:[BaseAction] = [BaseAction]()
    
    @State var selectedAction:BaseAction?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        List(actions, id: \.self,  selection: $selectedAction, rowContent: {action in
            switch action{
            case .display(let base):
                let button=Button(role: .destructive, action: {
                    delete(base: action)
                }, label: {
                    Label(title: {
                        Text("Remove")
                    }, icon: {
                        Image(systemName: "trash")
                    })
                })
                
                HStack{
                    Text(Output.numeric(base: base).description)
                    Spacer()
                }.swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                    button
                })
                    .contextMenu(menuItems: {
                        button
                    })
                
            case .insert(let base):
                BaseEditingView(editingDone: {b in
                    
                    withAnimation{
                        let newActions=actions.filter({$0 != action}) + [.display(base: b)]
                        self.actions=newActions.sorted()
                    }
                }, base: base, invalidBases: self.actions.compactMap({b in
                    switch b{
                    case .display(let base):
                        return base
                    case .insert(_):
                        return nil
                    }
                }))
            }
            
        })
            .navigationTitle(Text("Base Selection"))
            .toolbar(content: {
#if os(macOS)
                
                ToolbarItemGroup(placement: .automatic, content: {
                    HStack{
                        Button(action: {
                            self.actions.append(.insert(base: 12))
                        }, label: {
                            Label(title: {}, icon: {
                                Image(systemName: "plus")
                            }).help(Text("Insert Item"))
                        })
                        Button(action: {
                            if let base=self.selectedAction{
                                self.delete(base: base)
                            }
                            
                        }, label: {
                            Label(title: {}, icon: {
                                Image(systemName: "minus")
                            }).help(Text("Delete Item"))
                        }).disabled(selectedAction == nil)
                        
                    }.disabled(actions.contains(where: {action in
                        switch action{
                        case .insert(_):
                            return true
                        case .display(_):
                            return false
                        }
                        
                    }))
                })
                
                
                
                ToolbarItem(placement: .confirmationAction, content: {
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label(title: {Text("Done")}, icon: {
                            
                        })
                    })
                    
                })
#else
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.actions.append(.insert(base: 12))
                    }, label: {
                        Label(title: {Text("Insert Item")}, icon: {
                            Image(systemName: "plus")
                        })
                    }).disabled(actions.contains(where: {action in
                        switch action{
                        case .insert(_):
                            return true
                        case .display(_):
                            return false
                        }
                    }))
                })
                
#endif
            })
            .onAppear(perform: {
                self.actions=preferredBases.bases
                    .filter({$0 != 10})
                    .map({BaseAction.display(base: $0)})
            })
            .onDisappear(perform: {
                let bases = (self.actions.compactMap({action->Int? in
                    switch action{
                    case .display(let base):
                        return base
                    default:
                        return nil
                    }
                }) + [10]).sorted()
                self.preferredBases=BasePreference(bases: bases)
                let filteredOutputs=self.outputPreference.outputs.filter({output in
                    switch output{
                    case .numeric(let base):
                        return self.preferredBases.bases.contains(base)
                    default:
                        return true
                    }
                })
                outputPreference = OutputPreference(outputs: filteredOutputs)
            })
#if os(macOS)
            .onDeleteCommand(perform: {
                if let base=selectedAction{
                    delete(base: base)
                }
            })
            .onExitCommand(perform: {
                dismiss()
            })
#endif
        
    }
    
    func delete(base:BaseAction){
        withAnimation{
            self.actions=actions.filter({$0 != base})
        }
    }
    
    
    
    
    
}

struct BaseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            BaseSelectionView()
        }
    }
}

