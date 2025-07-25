//
//  PerformanceTargetsListView.swift
//  DiamondDeskERP
//
//  Created by J.Michael McDermott on 7/20/25.
//

import SwiftUI

struct PerformanceTargetsListView: View {
    @StateObject var viewModel: PerformanceTargetsViewModel
    @State private var showingCreation = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        SimpleAdaptiveNavigationView(path: $navigationPath) {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Performance Targets...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else if viewModel.targets.isEmpty {
                    Text("No performance targets found.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(viewModel.targets) { target in
                            NavigationLink(
                                destination: NavigationRouter.shared.selectedPerformanceTarget == target ? nil : nil
                            ) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(target.name)
                                            .font(.headline)
                                        Text(target.metricType.rawValue)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(target.targetValue, specifier: "%.1f") \(target.unit)")
                                        .font(.subheadline)
                                }
                            }
                            .onTapGesture {
                                NavigationRouter.shared.selectedPerformanceTarget = target
                                NavigationRouter.shared.tasksPath.append(.performanceTargetDetail(target.id.uuidString))
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    let target = viewModel.targets[index]
                                    await viewModel.deleteTarget(target)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Performance Targets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreation = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            // Creation sheet
            .sheet(isPresented: $showingCreation) {
                PerformanceTargetCreationView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadTargets()
            }
        }
    }
}

#Preview {
    PerformanceTargetsListView(viewModel: PerformanceTargetsViewModel())
}
