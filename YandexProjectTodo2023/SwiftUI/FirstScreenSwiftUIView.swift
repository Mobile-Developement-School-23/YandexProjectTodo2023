//
//  FirstScreenSwiftUIView.swift
//  YandexProjectTodo2023
//
//  Created by Дмитрий Гусев on 16.07.2023.
//

import SwiftUI

struct FirstScreenSwiftUIView: View {
    
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "circle").foregroundColor(.gray)
                    Text("Hello")
                    Spacer()
                    Image(systemName: "chevron.right")
                }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        print("done action")
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .tint(.green)
                }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        print("trash action")
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        print("info action")
                        self.showModal.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(.gray)
                }
                
                    HStack {
                        Image(systemName: "circle").foregroundColor(.red)
                        Image(systemName: "exclamationmark.2").foregroundColor(.red)
                        VStack {
                            Text("Hellosdcsd csdc sdc sdcsdc sdc sdc sdc sdc sdc sdc sdc sdc sdc sdc sdc sdcsdcs dc sdc sdc sdc s cs sdsfsdfsdf sdf sd dsfs").lineLimit(3)
                            HStack {
                                Image(systemName: "calendar").foregroundColor(.gray).font(.system(size: 14))
                                Text("18 июля").foregroundColor(.gray).font(.system(size: 14))
                                Spacer()
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            print("done action")
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .tint(.green)
                    }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            print("trash action")
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            print("info action")
                            self.showModal.toggle()
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                        .tint(.gray)
                    }
                
                HStack {
                    Image(systemName: "circle").foregroundColor(.gray)
                    Image(systemName: "arrow.down").foregroundColor(.gray)
                    VStack {
                        HStack {
                            Text("Helfsdfcdcfs").lineLimit(3)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "calendar").foregroundColor(.gray).font(.system(size: 14))
                            Text("18 июля").foregroundColor(.gray).font(.system(size: 14))
                            Spacer()
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        print("done action")
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .tint(.green)
                }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        print("trash action")
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        print("info action")
                        self.showModal.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .tint(.gray)
                }
            }
            .sheet(isPresented: $showModal) {
                SecondScreenSwiftUIView()
            }
            .navigationTitle(Text("Мои дела"))
        }

    }
        
}

struct FirstScreenSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreenSwiftUIView()
    }
}
