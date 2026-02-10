import SwiftUI
import SwiftData

struct ChecklistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChecklistItem.createdAt) private var items: [ChecklistItem]
    @State private var newItem = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Spacing.md) {
                HStack {
                    TextField("Add deployment task", text: $newItem)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") { addItem() }
                        .buttonStyle(.borderedProminent)
                }

                List {
                    ForEach(items) { item in
                        Button {
                            item.isComplete.toggle()
                            try? modelContext.save()
                        } label: {
                            HStack {
                                Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                                Text(item.title)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .navigationTitle("CAT Checklist")
        }
    }

    private func addItem() {
        guard !newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        modelContext.insert(ChecklistItem(title: newItem))
        try? modelContext.save()
        newItem = ""
    }
}
