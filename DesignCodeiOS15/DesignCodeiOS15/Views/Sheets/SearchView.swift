//
//  SearchView.swift
//  DesignCodeiOS15
//
//  Created by Stanly Shiyanovskiy on 28.07.2022.
//

import SwiftUI

struct SearchView: View {
    
    @State var text = ""
    @State var show = false
    @Namespace var namespace
    @State var selectedIndex = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    content
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous)
                )
                .strokeStyle(cornerRadius: 30)
                .padding(20)
                .background(
                    Rectangle()
                        .fill(.regularMaterial)
                        .frame(height: 200)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .blur(radius: 20)
                        .offset(y: -200)
                )
                .background(
                    Image("Blob 1")
                        .offset(x: -100, y: -200)
                )
            }
            .searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("SwiftUI, React, UI Design")
            ) {
                ForEach(suggestions) { suggestion in
                    Button {
                        text = suggestion.text
                    } label: {
                        Text(suggestion.text)
                            .searchCompletion(suggestion.text)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done").bold()
            })
            .sheet(isPresented: $show) {
                CourseView(namespace: namespace, course: courses[selectedIndex], show: $show)
            }
        }
    }
    
    var content: some View {
        ForEach(Array(courses.enumerated()), id: \.offset) { index, course in
            if course.title.contains(text) || text == "" {
                if index != 0 { Divider() }
                Button {
                    show.toggle()
                    selectedIndex = index
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(course.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .background(Color("Background"))
                            .mask(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(course.title).bold()
                                .foregroundColor(.primary)
                            Text(course.text)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical, 4)
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
