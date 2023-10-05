//
//  ContentView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFood: Food?
    @State private var showInfo: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    if selectedFood != nil {
                        Text(selectedFood!.image)
                            .font(.system(size: 250))
                            .minimumScaleFactor(0.5) // 放不下的时候缩放倍数
                            .lineLimit(1)
                            .id(selectedFood!.name)
                    } else {
                        Image("dinner")
                            .resizable()
                            .scaledToFit()
                        
                    }
                }
                .frame(height: 250)

                Text("今天吃什么？")
                    .fontWeight(.bold)

                if selectedFood != nil {
                    HStack {
                        Text(selectedFood?.name ?? "")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.accentColor)
                            .id(selectedFood?.name)
                            .transition(.asymmetric(insertion: .opacity.animation(.easeInOut), removal: .opacity.animation(.easeInOut)))
                        //                    .transition(.slide.combined(with: .scale))
                        Button{
                            showInfo.toggle()
                        }label: {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    Text("热量 \(String(format: "%.f", arguments: [selectedFood!.calorie])) 大卡")
                    
                    VStack{
                        if showInfo {
                            HStack {
                                VStack(spacing: 12) {
                                    Text("蛋白质")
                                    Text("\(String(format: "%.f", arguments: [selectedFood!.protein])) g")
                                }
                                
                                Divider().frame(width:1,height:30).padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    Text("脂肪")
                                    Text("\(String(format: "%.f", arguments: [selectedFood!.fat])) g")
                                }
                                
                                Divider().frame(width:1,height:30).padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    Text("碳水")
                                    Text("\(String(format: "%.f", arguments: [selectedFood!.carb])) g")
                                }
                            }
                            .font(.title2)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.systemBackground)))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .clipped() // 动画开始时防止与上方view重叠
                }

                Spacer()

                Button {
    //                withAnimation {
    //                    selectedFood = food.shuffled().first{$0 != selectedFood}
    //                }
                    selectedFood = Food.examples.shuffled().first { $0 != selectedFood }
                } label: {
                    Text(selectedFood == nil ? "告诉我" : "换一个")
                        .frame(width: 200)
                        .transformEffect(.identity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    selectedFood = nil
                    showInfo = false
                } label: {
                    Text("重置").frame(width: 200)
                }
            }
            .padding()
            .frame(maxWidth: .infinity,minHeight: UIScreen.main.bounds.height-100)
            .font(.title)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .animation(.spring(dampingFraction: 0.55), value: showInfo)
            .animation(.easeInOut, value: selectedFood)
        }
        .background(Color(.secondarySystemBackground))

    }
}

extension ContentView {
    init(selectedFood: Food) {
        _selectedFood = .init(wrappedValue: selectedFood)
    }
}

#Preview {
    ContentView()
}

extension PreviewDevice{
    static let iPad = PreviewDevice(rawValue: "iPad (10th generation)")
}
