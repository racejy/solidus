//
//  SolidusTogglePillSelector.swift
//  SolidusApp
//
//  Created by racecar on 11/20/25.
//

import SwiftUI

struct SolidusPillSelector<Data: RandomAccessCollection, ID: Hashable>: View {

    let items: Data
    let idKeyPath: KeyPath<Data.Element, ID>
    let labelKeyPath: KeyPath<Data.Element, String>

    @Binding var selected: ID?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: idKeyPath) { item in
                    pill(
                        label: item[keyPath: labelKeyPath],
                        id: item[keyPath: idKeyPath]
                    )
                }
            }
            .padding(.vertical, 6)
        }
    }

    private func pill(label: String, id: ID) -> some View {
        let isSelected = (selected == id)

        return Text(label)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                ZStack {
                    if isSelected {
                        Color("background_teal").opacity(0.85)
                    } else {
                        SolidusGlass(
                            color: Color.white,
                            opacity: 0.16
                        )
                    }
                }
                .clipShape(Capsule())
            )
            .onTapGesture {
                withAnimation(.smooth(duration: 0.15)) {
                    selected = id
                }
            }
    }
}
