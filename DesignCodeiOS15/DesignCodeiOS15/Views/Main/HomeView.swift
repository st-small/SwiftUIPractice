//
//  HomeView.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 23.07.2022.
//

import SwiftUI

struct HomeView: View {
    
    @State var hasScrolled = false
    @Namespace var namespace
    @State var show = false
    @State var showStatusBar = true
    @State var selectedID = UUID()
    @State var showCourse = false
    @State var selectedIndex = 0
    @EnvironmentObject var model: Model
    @AppStorage("isLiteMode") var isLiteMode = true
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                scrollDetection
                
                featured
                
                Text("Courses".uppercased())
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                    if !show {
                        cards
                    } else {
                        detail
                    }
                }
                .padding(.horizontal, 20)
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 70)
            }
            .overlay(
                NavigationBar(title: "Featured", hasScrolled: $hasScrolled)
            )
            
            if show {
                ForEach(courses) { course in
                    if course.id == selectedID {
                        CourseView(namespace: namespace, course: course, show: $show)
                            .zIndex(1)
                            .transition(.asymmetric(
                                insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                                removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.3)))
                            )
                    }
                }
            }
        }
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                showStatusBar = !newValue
            }
        }
    }
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                hasScrolled = value < 0
            }
        }
    }
    
    var featured: some View {
        TabView {
            ForEach(Array(featuredCourses.enumerated()), id: \.offset) { index, course in
                GeometryReader { geo in
                    let minX = geo.frame(in: .global).minX
                    
                    FeaturedItem(course: course)
                        .frame(maxWidth: 500)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .rotation3DEffect(
                            .degrees(minX / -10),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .shadow(color: Color("Shadow").opacity(isLiteMode ? 0 : 0.3), radius: 5, x: 0, y: 3)
                        .blur(radius: abs(minX / 40))
                        .overlay(
                            Image(course.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 230)
                                .offset(x: 32, y: -80)
                                .offset(x: minX / 2)
                        )
                        .onTapGesture {
                            showCourse.toggle()
                            selectedIndex = index
                        }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 430)
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
        )
        .sheet(isPresented: $showCourse) {
            CourseView(namespace: namespace, course: featuredCourses[selectedIndex], show: $showCourse)
        }
    }
    
    var cards: some View {
        ForEach(courses) { course in
            CourseItem(namespace: namespace, course: course, show: $show)
                .onTapGesture {
                    withAnimation(.openCard) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedID = course.id
                    }
            }
        }
    }
    
    var detail: some View {
        ForEach(courses) { course in
            Rectangle()
                .fill(.white)
                .frame(height: 300)
                .cornerRadius(30)
                .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                .opacity(0.3)
            .padding(.horizontal, 30)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(Model())
    }
}
