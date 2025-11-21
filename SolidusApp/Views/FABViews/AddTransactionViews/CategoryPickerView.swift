//
//  CategoryPickerView.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @Binding var selected: String

    @State private var searchText = ""

    // GROUPED CATEGORIES
    private var groupedCategories: [(group: String, items: [CategoryItem])] {
        let dict = Dictionary(grouping: Categories.all, by: { $0.group })
        return dict.keys.sorted().map { key in
            (
                group: key,
                items: dict[key]!.sorted { $0.name < $1.name }
            )
        }
    }

    var body: some View {

        SolidusSearchSheetPage(
            title: "Select Category",
            content: {

                ForEach(groupedCategories, id: \.group) { section in

                    let filtered = section.items.filter {
                        searchText.isEmpty ||
                        $0.name.lowercased().contains(searchText.lowercased())
                    }

                    if !filtered.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {

                            SolidusSectionLabel(text: section.group.uppercased())

                            ForEach(filtered) { cat in
                                categoryRow(cat)
                            }
                        }
                    }
                }

            },
            bottomBar: {
                SolidusSearchBar(
                    text: $searchText,
                    placeholder: "Search categories…"
                )
            }
        )
    }

    // CATEGORY ROW
    private func categoryRow(_ cat: CategoryItem) -> some View {
        HStack(spacing: 16) {

            Image(systemName: cat.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("background_teal"))
                .frame(width: 32, height: 32)

            Text(cat.name)
                .font(.system(size: 17))
                .foregroundColor(.primary)

            Spacer()

            if selected == cat.name {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color("background_teal"))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(
            SolidusGlass(
                color: scheme == .light ? .white : .black.opacity(0.9),
                opacity: scheme == .light ? 0.16 : 0.22
            )
        )
        .solidusRounded(
            radius: 18,
            shadowOpacity: 0.10,
            shadowRadius: 8,
            shadowY: 3
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(SolidusAnimation.smooth) {
                selected = cat.name
                dismiss()
            }
        }
    }
}
