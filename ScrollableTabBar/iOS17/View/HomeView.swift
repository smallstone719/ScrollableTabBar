//
//  HomeView.swift
//  ScrollableTabBar
//
//  Created by Thach Nguyen Trong on 4/20/24.
//

import SwiftUI

struct HomeView: View {
    /// View Properties
    @State private var tabs: [TabModel] = [
        .init(id: TabModel.Tab.research),
        .init(id: TabModel.Tab.deployment),
        .init(id: TabModel.Tab.analytics),
        .init(id: TabModel.Tab.audience),
        .init(id: TabModel.Tab.privacy)
    ]
    @State private var activeTab: TabModel.Tab? = .research
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            ScrollableTabBar()
            
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs) { tab in
                            /// Khi sử dụng .scrollTargetBehavior(.paging)
                            /// cần lưu ý là content trong ScrollView phải fullscreen width
                            /// nếu không thì paging sẽ không hoạt động chính xác.
                            Text(tab.id.rawValue)
                                .frame(width: size.width, height: size.height)
                                .contentShape(.rect)
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                /// Nó thì rất quan trọng để thông báo rằng scrollPosition
                /// phải khớp với với id của tab trong vòng lặp
                /// Trong trường hợp này id là 1 Tab enum được khai báo trong TabModel
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                /// Cập nhật trạng thái của tabBar button khi mainView
                /// thay đổi
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    withAnimation(.snappy) {
                        tabBarScrollState = newValue
                        activeTab = newValue
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 4) {
            Image(.youtube)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
            Text("YouTube")
                .font(.title2)
                .fontWeight(.medium)
                .tracking(-0.5)
                .fontWidth(.condensed)
            Spacer(minLength: 0)
            
            Button("", systemImage: "plus.circle") {
                
            }
            .font(.title2)
            .tint(.primary)
            Button("", systemImage: "bell") {
                
            }
            .font(.title2)
            .tint(.primary)
            Button {
                
            } label: {
                Image(.profile)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        /// Overlay
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func ScrollableTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20, content: {
                ForEach($tabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    }, label: {
                        Text(tab.id.rawValue)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : Color.gray)
                            .padding(.vertical, 12)
                            .contentShape(.rect)
                    })
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            })
            .scrollTargetLayout()
        }
        /// Đưa tab button được chọn vào trung tâm của màn hình
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
       
        .overlay(alignment: .bottom, content: {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                let inputRange = tabs.indices.compactMap { return CGFloat($0)}
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX}
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }) 
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
