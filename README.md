# TodoListApp

A Reminders-style to-do list application for iOS, iPadOS, and macOS built with SwiftUI.

## Features

- ✅ Create, edit, and delete tasks
- 📅 Set due dates in **UK format (DD/MM/YY)**
- ⏰ Set due times in **24-hour format**
- 📝 Add notes to tasks
- 🎯 Priority levels (None, Low, Medium, High)
- ✔️ Mark tasks as complete/incomplete
- 🔍 Search tasks
- 📱 Adaptive UI for iPhone, iPad, and Mac
- 💾 Persistent storage using UserDefaults

## Screenshots

The app features a clean, Apple Reminders-inspired design with:
- Sidebar navigation (iPad/Mac)
- Task list with swipe actions
- Detailed task view with editing
- Add task form with date/time pickers

## Requirements

- iOS 17.0+
- iPadOS 17.0+
- macOS 14.0+
- Xcode 15.0+

## Project Structure

```
TodoListApp/
├── TodoListApp/
│   ├── TodoListApp.swift          # App entry point
│   ├── Models/
│   │   └── Task.swift             # Task model with UK date formatting
│   ├── ViewModels/
│   │   └── TaskStore.swift        # Data management and persistence
│   ├── Views/
│   │   ├── ContentView.swift      # Main adaptive view
│   │   ├── SidebarView.swift      # Sidebar for iPad/Mac
│   │   ├── TaskListView.swift     # Task list display
│   │   ├── TaskRowView.swift      # Individual task row
│   │   ├── AddTaskView.swift      # Create new task
│   │   └── TaskDetailView.swift   # Task details and editing
│   └── Assets.xcassets/
│
└── TodoListAppUITests/            # XCUI Tests with POM
    ├── Pages/
    │   ├── BasePage.swift         # Base page object
    │   ├── TaskListPage.swift     # Task list page object
    │   ├── AddTaskPage.swift      # Add task page object
    │   └── TaskDetailPage.swift   # Task detail page object
    └── Tests/
        ├── TaskListTests.swift    # Task list UI tests
        ├── AddTaskTests.swift     # Add task UI tests
        ├── TaskDetailTests.swift  # Task detail UI tests
        └── EndToEndTests.swift    # E2E test scenarios
```

## Date & Time Formats

The app uses UK date and time formats as requested:

- **Date**: `DD/MM/YY` (e.g., `09/01/26`)
- **Time**: `HH:mm` 24-hour format (e.g., `14:30`)
- **Combined**: `DD/MM/YY at HH:mm` (e.g., `09/01/26 at 14:30`)

## Installation

1. Open `TodoListApp.xcodeproj` in Xcode
2. Select your target device (iPhone, iPad, or Mac)
3. Build and run (⌘R)

### Creating the Xcode Project

Since this is source code only, create a new project in Xcode:

1. Open Xcode → Create New Project
2. Select "Multiplatform" → "App"
3. Product Name: `TodoListApp`
4. Team: Your development team
5. Organization Identifier: Your identifier
6. Interface: SwiftUI
7. Language: Swift
8. Copy the source files into the project

## UI Tests

The project includes comprehensive XCUI tests using the **Page Object Model (POM)** pattern.

### Page Objects

| Page Object | Description |
|-------------|-------------|
| `BasePage` | Base class with common utilities |
| `TaskListPage` | Main task list interactions |
| `AddTaskPage` | Create task form interactions |
| `TaskDetailPage` | Task detail view interactions |

### Test Suites

| Test Suite | Coverage |
|------------|----------|
| `TaskListTests` | List display, navigation, deletion |
| `AddTaskTests` | Form validation, task creation |
| `TaskDetailTests` | Viewing, editing, completion, deletion |
| `EndToEndTests` | Complete user flows |

### Running Tests

```bash
# Run all UI tests
xcodebuild test -scheme TodoListApp -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -scheme TodoListApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:TodoListAppUITests/TaskListTests
```

Or in Xcode:
1. Select test scheme
2. Press ⌘U to run tests
3. View results in Test Navigator

### Test Features

- ✅ Page Object Model for maintainability
- ✅ Wait utilities for async operations
- ✅ Accessibility identifiers for reliable element location
- ✅ UK date/time format verification
- ✅ End-to-end test scenarios
- ✅ Swipe actions testing
- ✅ Form validation testing

## Accessibility Identifiers

Key elements have accessibility identifiers for UI testing:

| Identifier | Element |
|------------|---------|
| `addTaskButton` | Add task button |
| `taskListView` | Task list view |
| `taskTitleField` | Task title input |
| `taskNotesField` | Task notes input |
| `dueDatePicker` | Due date picker |
| `dueTimePicker` | Due time picker |
| `priorityPicker` | Priority selector |
| `saveTaskButton` | Save button |
| `cancelButton` | Cancel button |
| `editButton` | Edit button |
| `deleteTaskButton` | Delete button |
| `taskStatus` | Task status display |

## Architecture

- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **Environment Objects**: Shared state across views
- **Page Object Model**: UI test architecture

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## License

MIT License

