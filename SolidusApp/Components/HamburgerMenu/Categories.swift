//
//  Categories.swift
//  SolidusApp
//
//  Created by racecar on 11/19/25.
//

import Foundation

struct CategoryItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let group: String
}

enum Categories {
    static let all: [CategoryItem] = [
        
        // Essentials
        CategoryItem(name: "Rent",               icon: "house.fill",                     group: "Essentials"),
        CategoryItem(name: "Housing",            icon: "house.circle.fill",              group: "Essentials"),
        CategoryItem(name: "Utilities",          icon: "bolt.fill",                      group: "Essentials"),
        CategoryItem(name: "Car",                icon: "car.fill",                       group: "Essentials"),
        CategoryItem(name: "Phones & Internet",  icon: "wifi",                           group: "Essentials"),
        CategoryItem(name: "Fees",               icon: "exclamationmark.circle.fill",    group: "Essentials"),
        
        // Everyday Spending
        CategoryItem(name: "Food",               icon: "fork.knife",                     group: "Everyday Spending"),
        CategoryItem(name: "Groceries",          icon: "cart.fill",                      group: "Everyday Spending"),
        CategoryItem(name: "Shopping",           icon: "bag.fill",                       group: "Everyday Spending"),
        CategoryItem(name: "Personal Care",      icon: "sparkles",                       group: "Everyday Spending"),
        CategoryItem(name: "Pets",               icon: "pawprint.fill",                  group: "Everyday Spending"),
        
        // Leisure
        CategoryItem(name: "Entertainment",      icon: "sparkles.tv",                    group: "Leisure"),
        CategoryItem(name: "Travel",             icon: "airplane.departure",             group: "Leisure"),
        CategoryItem(name: "Gifts",              icon: "gift.fill",                      group: "Leisure"),
        
        // Health
        CategoryItem(name: "Medical",            icon: "cross.case.fill",                group: "Health"),
        CategoryItem(name: "Fitness",            icon: "figure.strengthtraining.traditional", group: "Health"),
        
        // Financial
        CategoryItem(name: "Income",             icon: "arrow.down.circle.fill",         group: "Financial"),
        CategoryItem(name: "Investing",          icon: "chart.line.uptrend.xyaxis",      group: "Financial"),
        CategoryItem(name: "Crypto",             icon: "bitcoinsign.circle.fill",        group: "Financial"),
        CategoryItem(name: "Dividends",          icon: "chart.pie.fill",                 group: "Financial"),
        CategoryItem(name: "Savings",            icon: "dollarsign.circle.fill",         group: "Financial"),
        CategoryItem(name: "Interest Income",    icon: "banknote.fill",                  group: "Financial"),
        CategoryItem(name: "Refunds",            icon: "arrow.uturn.backward.circle",    group: "Financial"),
        CategoryItem(name: "Rewards",            icon: "star.circle.fill",               group: "Financial"),
        CategoryItem(name: "Loans",              icon: "creditcard.fill",                group: "Financial"),
        CategoryItem(name: "Insurance",          icon: "shield.fill",                    group: "Financial"),
        
        // Personal Growth
        CategoryItem(name: "Donations",          icon: "heart.fill",                     group: "Personal Growth"),
        CategoryItem(name: "Education",          icon: "graduationcap.fill",             group: "Personal Growth"),
        CategoryItem(name: "Work",               icon: "briefcase.fill",                 group: "Personal Growth"),
        
        // Misc
        CategoryItem(name: "Other",              icon: "square.grid.2x2.fill",           group: "Misc")
    ]
}
