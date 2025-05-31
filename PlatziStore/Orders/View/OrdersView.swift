//
//  OrdersView.swift
//  PlatziStore
//
//  Created by mac on 29/05/25.
//

import SwiftUI
import CoreData

struct OrdersView: View {
    @StateObject var viewModel: OrdersViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: OrdersViewModel(context: context))
    }

    var body: some View {
        List {
            if viewModel.orders.isEmpty {
                Text("No orders found.")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.orders, id: \.id) { order in
                    Section(header: Text("Order - \(formattedDate(order.date))")
                        .foregroundStyle(.white)) {
                        ForEach(order.itemsArray, id: \.self) { item in
                            HStack {
                                AsyncImage(url: URL(string: item.imageUrl ?? .empty)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                                VStack(alignment: .leading) {
                                    Text(item.name ?? .empty)
                                        .font(.headline)
                                    Text("Quantity: \(item.quantity)")
                                        .font(.subheadline)
                                }

                                Spacer()

                                Text("$\(Double(item.price) * Double(item.quantity), specifier: "%.2f")")
                            }
                        }

                        HStack {
                            Spacer()
                            Text("Total: $\(order.totalAmount)")
                                .bold()
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Your Orders")
        .task {
            await viewModel.fetchOrders()
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
