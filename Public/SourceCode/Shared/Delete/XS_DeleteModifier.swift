//
//  XS_DeleteModifier.swift
//  XSGitPro
//
//  Created by 韩云智 on 2023/6/8.
//

import SwiftUI

extension View {
    func xsDelete(_ onDelete: @escaping () -> Void) -> ModifiedContent<Self, XS_DeleteModifier> {
        let id = UUID()
        return modifier(XS_DeleteModifier(onDelete: onDelete, id: id, currentId: .constant(id)))
    }
    func xsDelete(_ currentId: Binding<UUID?>, onDelete: @escaping () -> Void) -> ModifiedContent<Self, XS_DeleteModifier> {
        modifier(XS_DeleteModifier(onDelete: onDelete, id: UUID(), currentId: currentId))
    }
}

struct XS_DeleteModifier: ViewModifier {
    let onDelete: () -> Void
    let id: UUID
    @Binding var currentId: UUID?
    
    @State private var isPresented: Bool = false
    @State private var dragOffset: CGFloat = .zero
    @State private var currentOffset: CGFloat = .zero
    private var offset: CGFloat {
        dragOffset + currentOffset
    }
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    private let buttonWidth: CGFloat = 60
    
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            ZStack(alignment: .leading) {
                Color.red
                    .frame(width: screenWidth)
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
            }
            .frame(width: 0, alignment: .leading)
            .onTapGesture {
                currentOffset = -screenWidth
                isPresented = true
            }
        }
        .offset(x: offset)
        .animation(.spring(response: 1, dampingFraction: 1), value: offset)
        .clipped()
        .gesture(dragGesture)
        .confirmationDialog("是否删除?", isPresented: $isPresented) {
            Button("删除", role: .destructive) {
                onDelete()
            }
            Button("取消", role: .cancel) {
                currentOffset = .zero
            }
        }
        .onChange(of: currentId) { newValue in
            if newValue == id { return }
            currentOffset = .zero
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                currentId = id
                if currentOffset + value.translation.width <= 0 {
                    dragOffset = value.translation.width
                }
            }
            .onEnded { value in
                let screenWidth = screenWidth
                let offset = offset
                dragOffset = .zero
                if offset > -buttonWidth/2 {
                    currentOffset = .zero
                } else if offset > -screenWidth/2 {
                    currentOffset = -buttonWidth
                } else {
                    currentOffset = -screenWidth
                    isPresented = true
                }
            }
    }
}

#if DEBUG
struct XS_DeleteModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .xsDelete {}
            .frame(width: UIScreen.main.bounds.size.width, height: 50)
    }
}
#endif
