import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var books = [
        Book(title: "欢迎使用 SwiftReader", author: "SwiftReader"),
        Book(title: "把自己的书放进书架", author: "本地阅读")
    ]
    @State private var selectedBook: Book?
    @State private var showingImporter = false
    @State private var importMessage: String?

    private let columns = [GridItem(.adaptive(minimum: 135), spacing: 18)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("你的下一段故事").font(.largeTitle.bold())
                        Text("本地书籍 · 安静阅读 · 自由定制").foregroundStyle(.secondary)
                    }
                    .padding(.top, 12)

                    Button { showingImporter = true } label: {
                        Label("导入 TXT 书籍", systemImage: "plus")
                            .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 15)
                    }
                    .buttonStyle(.borderedProminent)

                    HStack {
                        Text("我的书架").font(.title2.bold())
                        Spacer()
                        Text("\(books.count) 本").foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: columns, spacing: 22) {
                        ForEach(books) { book in
                            Button { selectedBook = book } label: {
                                VStack(alignment: .leading, spacing: 9) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(LinearGradient(colors: [.indigo.opacity(0.85), .purple.opacity(0.75)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        Image(systemName: "book.closed.fill")
                                            .font(.system(size: 34)).foregroundStyle(.white.opacity(0.92))
                                    }
                                    .frame(height: 175)
                                    Text(book.title).font(.headline).foregroundStyle(.primary).lineLimit(2)
                                    Text(book.author).font(.caption).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingImporter = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("导入书籍")
                }
            }
            .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.plainText], allowsMultipleSelection: false, onCompletion: handleImport)
            .sheet(item: $selectedBook) { ReaderView(book: $0) }
            .alert("导入提示", isPresented: Binding(
                get: { importMessage != nil },
                set: { if !$0 { importMessage = nil } }
            )) {
                Button("好", role: .cancel) { importMessage = nil }
            } message: {
                Text(importMessage ?? "")
            }
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            do {
                let parsed = try PlainTextBookParser.parse(url: url)
                let book = Book(title: parsed.title, fileURL: url)
                books.insert(book, at: 0)
                selectedBook = book
            } catch {
                importMessage = error.localizedDescription
            }
        case .failure(let error):
            importMessage = error.localizedDescription
        }
    }
}

private struct ReaderView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @State private var content = "这本书已加入书架。导入 TXT 文件后即可开始阅读。"
    @State private var fontSize = 20.0
    @State private var isDark = false

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(content).font(.system(size: fontSize, design: .serif)).lineSpacing(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24).padding(.vertical, 28)
            }
            .background(isDark ? Color.black : Color(red: 0.98, green: 0.96, blue: 0.91))
            .foregroundStyle(isDark ? Color.white : Color.primary)
            .navigationTitle(book.title).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("完成") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Toggle("夜间模式", isOn: $isDark)
                        Slider(value: $fontSize, in: 16...30, step: 1) { Text("字号") }
                    } label: { Image(systemName: "textformat.size") }
                }
            }
            .task {
                guard let url = book.fileURL else { return }
                if let parsed = try? PlainTextBookParser.parse(url: url) { content = parsed.text }
            }
        }
    }
}
