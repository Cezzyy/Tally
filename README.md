# Tally

Your personal productivity companion that helps you stay on top of your tasks and projects.

## What is Tally?

Tally is a task and ticket management app that keeps everything organized in one simple, easy-to-use interface. Tally helps you track tasks, manage checklists, and stay productive.

## Features

- **Ticket Management** - Track tasks with priorities and statuses
- **Smart Checklists** - Break down projects into manageable steps
- **Dashboard Overview** - See your progress at a glance
- **Personalize Your Experience** - Light and dark themes
- **Works Everywhere** - Mobile, tablet, and desktop support
- **Always in Sync** - Real-time updates across all devices

## Quick Start

### Prerequisites

Make sure you have these installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (3.10.4 or higher)
- [Dart](https://dart.dev/get-dart) (comes with Flutter)
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for database setup)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/tally.git
   cd tally
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Open `.env` and add your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

   Or use the Makefile:
   ```bash
   make run
   ```

## Available Commands

The project includes a Makefile for common tasks:

```bash
make run          # Run the app
make build        # Generate code (Riverpod, Freezed, etc.)
make test         # Run all tests
make analyze      # Run code analysis
make format       # Format code
make clean        # Clean build files
```

## Database Setup

If you need to set up or update the database:

1. **Initialize Supabase** (first time only)
   ```bash
   supabase init
   ```

2. **Link to your project**
   ```bash
   supabase link --project-ref your-project-ref
   ```

3. **Apply migrations**
   ```bash
   supabase db push
   ```

## Project Structure

```
lib/
├── core/              # Core functionality (config, routing, logging)
├── features/          # Feature modules (auth, tickets, checklists, etc.)
│   ├── auth/         # Authentication
│   ├── tickets/      # Ticket management
│   ├── checklist/    # Checklist functionality
│   ├── home/         # Dashboard and home screen
│   └── settings/     # App settings
└── shared/           # Shared widgets and utilities
```

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management
- **Supabase** - Backend and authentication
- **Go Router** - Navigation
- **Freezed** - Immutable data classes
- **Material Design 3** - Modern UI design

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Format Code
```bash
dart format .
```

## Troubleshooting

**Build errors after pulling changes?**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Environment variables not loading?**
- Make sure `.env` file exists in the root directory
- Check that `.env` is listed in `pubspec.yaml` under assets

**Supabase connection issues?**
- Verify your credentials in `.env`
- Check that your Supabase project is active
- Ensure you've run the database migrations

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) to get started.

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and formatting (`make test && make format`)
5. Commit your changes (`git commit -m 'feat: add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

For detailed guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

Found a security vulnerability? Please review our [Security Policy](SECURITY.md) for responsible disclosure guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Version

Current version: **0.1.0 Beta**

---
