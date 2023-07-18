import SwiftUI

struct SecondScreenSwiftUIView: View {
    @State private var fullText: String = "Что надо сделать?"
    @State private var selection = 0
    @State private var switcher = false
    @State var selectedDate: Date = Date()

    var body: some View {
        
        NavigationView {
            
            List {
                
                Section {
                    VStack {
                        TextEditor(text: $fullText)
                            .foregroundColor(.gray)
                            .frame(height: 120, alignment: .leading)
                    }
                }
                
                Section {
                    VStack {
                        HStack {
                            Text("Важность")
                            Spacer()
                            Picker(selection: $selection, label: Text("")) {
                                Image(systemName: "arrow.down").tag(0)
                                Text("Нет").tag(1)
                                Image("exclamationmark.2").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 150, height: 40)
                        }
                                          
                    }
                    HStack {
                        VStack {
                            Text("Сделать до")
                            Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 14))
                                .bold()
                                .foregroundColor(Color.accentColor)
//                                .padding()
                                .animation(.spring(), value: selectedDate)
                                .frame(width: 100)
                        }
                        Toggle(isOn: $switcher) {
                        }
                    }

                    VStack {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                        
                    }
                }
                
            }
       
            .toolbar(content: {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Закрыть") {
                        print("close button")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Дело").bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Сохранить") {
                        print("save button")
                    }
                }
                
            })
            .background(.quaternary)
        }
    }
    
}

struct SecondScreenSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SecondScreenSwiftUIView()
    }
}
