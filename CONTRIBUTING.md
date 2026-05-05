# Contributing to Tally

Thank you for your interest in contributing to Tally! We welcome contributions from everyone, whether you're fixing a bug, adding a feature, or improving documentation.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)
- [Questions](#questions)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment. We expect all contributors to:

- Be respectful and considerate
- Welcome newcomers and help them get started
- Focus on what's best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

Before you begin, make sure you have:

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA recommended)
- Supabase CLI (for database work)

### Setting Up Your Development Environment

1. **Fork the repository**
   
   Click the "Fork" button at the top right of the repository page.

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/tally.git
   cd tally
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/tally.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```

6. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

7. **Run the app**
   ```bash
   flutter run
   ```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes** - Fix issues reported in GitHub Issues
- **New features** - Add new functionality (discuss first in an issue)
- **Documentation** - Improve README, code comments, or guides
- **Tests** - Add or improve test coverage
- **Code quality** - Refactoring, performance improvements
- **UI/UX** - Design improvements and user experience enhancements

### Before You Start

1. **Check existing issues** - Look for existing issues or discussions about your idea
2. **Create an issue** - If one doesn't exist, create an issue to discuss your proposal
3. **Wait for feedback** - For major changes, wait for maintainer feedback before starting work
4. **Claim the issue** - Comment on the issue to let others know you're working on it

## Development Workflow

### 1. Create a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or changes

### 2. Make Your Changes

- Write clean, readable code
- Follow the project's coding standards
- Add tests for new functionality
- Update documentation as needed
- Keep commits focused and atomic

### 3. Test Your Changes

Before submitting, make sure:

```bash
# Run tests
flutter test

# Run code analysis
flutter analyze

# Format code
dart format .

# Generate code if needed
dart run build_runner build --delete-conflicting-outputs
```

### 4. Commit Your Changes

Follow our commit message guidelines (see below).

### 5. Push and Create a Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and types
- Use `lowercase_with_underscores` for file names
- Prefer `const` over `final` when possible
- Use trailing commas for better formatting

### Project-Specific Guidelines

1. **State Management**
   - Use Riverpod for state management
   - Use code generation (`@riverpod` annotation)
   - Keep providers in `providers/` directories

2. **Architecture**
   - Follow the feature-based structure
   - Separate presentation, domain, and data layers
   - Use repository pattern for data access

3. **Widgets**
   - Keep widgets small and focused
   - Extract reusable widgets to `shared/widgets/`
   - Use `ConsumerWidget` or `ConsumerStatefulWidget` for Riverpod

4. **Naming Conventions**
   - Screens: `*_screen.dart` (e.g., `home_screen.dart`)
   - Widgets: `*_widget.dart` or descriptive names
   - Providers: `*_provider.dart`
   - Models: `*.dart` (e.g., `ticket.dart`)

5. **Code Organization**
   ```
   lib/
   ├── core/              # Core functionality
   ├── features/          # Feature modules
   │   └── feature_name/
   │       ├── data/      # Data layer (repositories, models)
   │       ├── domain/    # Business logic (if needed)
   │       └── presentation/  # UI layer (screens, widgets, providers)
   └── shared/            # Shared code
   ```

## Commit Guidelines

### Commit Message Format

Use clear, descriptive commit messages:

```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

### Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, no logic change)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks, dependencies

### Examples

```
feat: add dark mode toggle to settings

fix: resolve ticket deletion error on mobile

docs: update README with database setup instructions

refactor: simplify ticket repository logic
```

## Pull Request Process

### Before Submitting

- [ ] Code follows the project's style guidelines
- [ ] Tests pass (`flutter test`)
- [ ] Code analysis passes (`flutter analyze`)
- [ ] Code is formatted (`dart format .`)
- [ ] Documentation is updated (if needed)
- [ ] Commits follow the commit guidelines
- [ ] Branch is up to date with main

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issue
Closes #(issue number)

## Testing
Describe how you tested your changes

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Tests pass
- [ ] Code is formatted
- [ ] Documentation updated
```

### Review Process

1. A maintainer will review your PR
2. Address any requested changes
3. Once approved, a maintainer will merge your PR
4. Your contribution will be included in the next release

## Reporting Bugs

### Before Reporting

- Check if the bug has already been reported
- Try to reproduce the bug with the latest version
- Gather relevant information (OS, Flutter version, etc.)

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g., Windows, macOS, Linux]
- Flutter version: [e.g., 3.10.4]
- Tally version: [e.g., 0.1.0-beta]

**Additional context**
Any other relevant information.
```

## Suggesting Features

We love feature suggestions! Before suggesting:

1. Check if the feature has already been suggested
2. Consider if it aligns with the project's goals
3. Think about how it would benefit users

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Any other relevant information, mockups, or examples.
```

## Questions

Have questions? Here's how to get help:

- **General questions**: Open a [GitHub Discussion](https://github.com/YOUR_USERNAME/tally/discussions)
- **Bug reports**: Create a [GitHub Issue](https://github.com/YOUR_USERNAME/tally/issues)
- **Security issues**: See [SECURITY.md](SECURITY.md)

## Recognition

Contributors will be recognized in:

- The project's README (for significant contributions)
- Release notes
- GitHub's contributor graph

## License

By contributing to Tally, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to Tally! Your efforts help make this project better for everyone.
