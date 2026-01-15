# XSGitPro

A powerful macOS Git client built with SwiftUI and Composable Architecture.

## Features

### Git Core Operations
- **Clone Repositories** - Clone Git repositories from remote URLs
- **Commit Management** - Create and manage Git commits with ease
- **Push & Pull** - Sync changes with remote repositories
- **Branch Management** - View, create, and manage Git branches
- **Commit History** - Browse through commit history with detailed information
- **Status Monitoring** - Real-time Git repository status tracking

### File Management
- **Directory Browsing** - Navigate and manage local Git repositories
- **File Viewer** - View repository files with syntax highlighting
- **Built-in Code Editor** - Edit code files directly within the app

### User Interface
- **Tabbed Navigation** - Five main tabs: Files, Status, Branches, Commits, Search
- **Mask System** - Loading indicators, toast notifications, and overlay components
- **Navigation System** - Seamless in-app page navigation
- **Dark Mode Support** - Adapts to system appearance preferences

## Project Structure

```
XSGitPro/
├── XSGitPro/                    # Main app target
├── GitSimulator/                # Simulator target for testing
├── Public/SourceCode/
│   ├── Tools/                   # Utility classes
│   │   ├── Git/                # Git operations (XS_Git2, XS_Git*, XS_On*)
│   │   ├── Device/             # Device utilities
│   │   └── Task/               # Task management
│   ├── Extension/              # Swift extensions
│   ├── Shared/                 # Shared components
│   │   ├── Mask/              # UI overlay system
│   │   └── Delete/            # Delete modifiers
│   └── Views/                  # View modules
│       ├── Root/              # Root view
│       ├── Tabbar/            # Tab bar navigation
│       ├── Directory/         # Repository list
│       ├── Files/             # File browser
│       ├── Status/            # Git status
│       ├── Commits/           # Commit history
│       ├── Branches/          # Branch management
│       ├── Search/            # Search functionality
│       ├── Code/              # Code editor
│       ├── Navigation/        # Navigation system
│       ├── IAP/               # In-app purchases
│       └── Set/               # Settings
```

## Tech Stack

- **Language**: Swift
- **UI Framework**: SwiftUI
- **Architecture**: The Composable Architecture (TCA)
- **Git Library**: libgit2
- **Dependencies**: Managed via CocoaPods

### Dependencies

- **RevenueCat** - In-app purchase and subscription management
- **RATreeView** - Tree view for directory structure
- **CodeEditorView** - Code editing component
- **LanguageSupport** - Syntax highlighting

## Requirements

- macOS 13.0+
- Xcode 14.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/XSGitPro.git
cd XSGitPro
```

2. Install CocoaPods dependencies:
```bash
pod install
```

3. Open the workspace:
```bash
open XSGitPro.xcworkspace
```

4. Build and run in Xcode.

## Architecture

The app follows **The Composable Architecture (TCA)** pattern, providing:
- Unidirectional data flow
- Predictable state management
- Testable features
- Clear separation of concerns

Each feature consists of:
- **State** - The feature's data
- **Action** - Events that can occur
- **Reducer** - Logic that handles actions and updates state
- **View** - SwiftUI view that renders the state

## Targets

- **XSGitPro** - The main application with full functionality
- **GitSimulator** - A simulator target for testing and development

## License

[Add your license here]
