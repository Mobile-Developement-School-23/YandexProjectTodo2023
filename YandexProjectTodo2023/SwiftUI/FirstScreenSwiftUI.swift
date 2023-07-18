import SwiftUI
import UIKit

struct FirstScreenSwiftUI: View {
    
    var body: some View {
  
        NavigationView {
            ViewControllerViewSwiftUI()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .navigationTitle(Text("Мои дела"))
                .navigationBarTitleDisplayMode(.large)
        }
    }
  
}

struct FirstScreenSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreenSwiftUI()
    }
}

struct ViewControllerViewSwiftUI: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = FirstScreenViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerViewSwiftUI>) -> FirstScreenViewController {
        
        return FirstScreenViewController()
    }
    
    func updateUIViewController(_ uiViewController: FirstScreenViewController, context: UIViewControllerRepresentableContext<ViewControllerViewSwiftUI>) {
        
    }
}
