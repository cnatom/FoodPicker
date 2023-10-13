import SwiftUI
import PlaygroundSupport


//
//
//struct CustomTabBar: View {
//    @Binding var currentTab: Tab
//    
//    var body: some View {
//        GeometryReader{proxy in
//            HStack(spacing: 0){
//                ForEach(Tab.allCases,id: \.rawValue){tab in
//                    Button{
//                        withAnimation(.easeInOut(duration: 0.2)){
//                            currentTab = tab
//                        }
//                    } label: {
//                        Image(tab.rawValue)
//                            .renderingMode(.template)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height: 30)
//                            .frame(maxWidth: .infinity)
//                            .foregroundColor(currentTab == tab ? Color.white : Color.white.opacity(0.75))
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .frame(height: 30)
//        .padding(.bottom, 10)
//        .padding([.horizontal, .top])
//        .background{
//            Color.white.opacity(0.50)
//                .ignoresSafeArea()
//        }
//        //END OF VAR BODY
//    }
//    //END OF STRUCT
//}
//
//PlaygroundPage.current.setLiveView(CustomTabBar())
