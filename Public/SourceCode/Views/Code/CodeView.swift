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
    var directory: XS_GitDirectory
    @State var text: String = ""
    @State private var position: CodeEditor.Position = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        CodeEditor(text: $text, position: $position, messages: $messages, language: .swift())
            .environment(\.codeEditorTheme,
                          colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)
            .onAppear {
                readFile(file: file)
            }
            .onDisappear(perform: saveFile)
            .onChange(of: file) { newValue in
                saveFile()
                readFile(file: newValue)
            }
    }
    
    private func readFile(file: XS_GitFile) {
        if let path = file.entry?.path {
            let finalPath = directory.localURL.appendingPathComponent(path)
            debugPrint("finalPath:\(finalPath)")
            do {
                text = try String(contentsOfFile: finalPath.path)
            }catch {
                text = error.localizedDescription
            }
        }else{
            text = "Read Error"
        }
    }
    
    private func saveFile() {
        if let path = file.entry?.path {
            let finalPath = directory.localURL.appendingPathComponent(path)
            debugPrint("finalPath:\(finalPath)")
            do {
                try text.data(using: .utf8)?.write(to: finalPath)
            }catch {
                debugPrint("保存文件失败:\(error.localizedDescription)")
            }
        }
    }
}
