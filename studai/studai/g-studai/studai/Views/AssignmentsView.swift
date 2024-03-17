//
//  AssignmentsView.swift
//  studai
//
//  Created by Jose Morales on 3/16/24.
//

import SwiftUI

struct AssignmentsView: View {
    @State private var assignments: [Assignment] = []
    @State private var isShowingForm = false
    @State private var selectedAssignment: Assignment? // Added selectedAssignment state variable

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(assignments) { assignment in
                        VStack(alignment: .leading) {
                            Text("Name: \(assignment.name)")
                            Text("Due Date: \(assignment.dueDate, formatter: dateFormatter)")
                            Text("Description: \(assignment.description)")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedAssignment = assignment // Set the selected assignment
                            isShowingForm = true
                        }
                    }
                    .onDelete { indexSet in
                        deleteAssignments(at: indexSet)
                    }
                }
                .navigationTitle("Assignments")
                .navigationBarItems(trailing:
                    Button("Add Assignment") {
                        isShowingForm = true
                        selectedAssignment = nil // Clear selected assignment when adding a new one
                    }
                )
                .sheet(isPresented: $isShowingForm) {
                    AssignmentForm(assignments: $assignments, isShowingForm: $isShowingForm, selectedAssignment: selectedAssignment)
                }
            }
        }
        .onAppear {
            assignments = PersistenceManager.shared.loadAssignments()
        }
        .onDisappear {
            PersistenceManager.shared.saveAssignments(assignments)
        }
    }

    func deleteAssignments(at offsets: IndexSet) {
        assignments.remove(atOffsets: offsets)
    }
}

struct AssignmentForm: View {
    @Binding var assignments: [Assignment]
    @Binding var isShowingForm: Bool
    @State private var assignmentName: String
    @State private var dueDate: Date
    @State private var description: String

    var selectedAssignment: Assignment? // Added selectedAssignment parameter

    init(assignments: Binding<[Assignment]>, isShowingForm: Binding<Bool>, selectedAssignment: Assignment?) {
        self._assignments = assignments
        self._isShowingForm = isShowingForm
        self._assignmentName = State(initialValue: selectedAssignment?.name ?? "") // Initialize with selected assignment's name if available
        self._dueDate = State(initialValue: selectedAssignment?.dueDate ?? Date()) // Initialize with selected assignment's due date if available
        self._description = State(initialValue: selectedAssignment?.description ?? "") // Initialize with selected assignment's description if available
        self.selectedAssignment = selectedAssignment
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Assignment Name", text: $assignmentName)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                TextField("Description (Optional)", text: $description)
            }
            .navigationTitle(selectedAssignment != nil ? "Edit Assignment" : "New Assignment")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isShowingForm = false
                },
                trailing: Button("Save") {
                    if let selectedAssignment = selectedAssignment {
                        if let index = assignments.firstIndex(where: { $0.id == selectedAssignment.id }) {
                            assignments[index] = Assignment(id: selectedAssignment.id, name: assignmentName, dueDate: dueDate, description: description)
                        }
                    } else {
                        let newAssignment = Assignment(id: UUID(), name: assignmentName, dueDate: dueDate, description: description)
                        assignments.append(newAssignment)
                    }
                    isShowingForm = false
                }
            )
        }
    }
}


struct Assignment: Identifiable, Codable {
    var id: UUID
    var name: String
    var dueDate: Date
    var description: String
}

struct PersistenceManager {
    static let shared = PersistenceManager()
    private let assignmentsKey = "assignments"

    func loadAssignments() -> [Assignment] {
        guard let data = UserDefaults.standard.data(forKey: assignmentsKey) else { return [] }
        let decoder = JSONDecoder()
        if let assignments = try? decoder.decode([Assignment].self, from: data) {
            return assignments
        }
        return []
    }

    func saveAssignments(_ assignments: [Assignment]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(assignments) {
            UserDefaults.standard.set(data, forKey: assignmentsKey)
        }
    }
}

struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}
