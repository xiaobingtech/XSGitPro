//
//  CodeView.swift
//  XSGitPro
//
//  Created by 范东 on 2023/7/13.
//

import SwiftUI
import CodeEditorView
import LanguageSupport
import ComposableArchitecture

struct CodeView: View {
    
    var file: XS_GitFile
    @State var text: String = ""
    @State private var position: CodeEditor.Position = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        CodeEditor(text: $text, position: $position, messages: $messages, language: .swift())
            .environment(\.codeEditorTheme,
                          colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)
            .onAppear(perform: readFile)
    }
    
    private func readFile() {
        text = textFromFile(file: file)
    }
    
    private func textFromFile(file: XS_GitFile) -> String {
        if let path = file.entry?.path {
            debugPrint("当前文件路径:\(path)")
            do {
                let string = try String(contentsOfFile: path)
                return string
            }catch {
                return error.localizedDescription
            }
        }else{
            return "Read Error"
        }
    }
}
