# Getting Started - NovaCorp Verifier Portal

## Quick Start

### Step 1: Navigate to the project
```bash
cd verifier-portal/code
```

### Step 2: Run the app
```bash
make run
```

Or directly:
```bash
flutter run -d web-server --web-port 4000 --web-hostname 127.0.0.1
```

### Step 3: Open in browser

Once you see the message: `lib/main.dart is being served at http://127.0.0.1:4000`

Visit: **http://localhost:4000**

---

## Accessing Different Routes

| Page | URL | Purpose |
|------|-----|---------|
| Jobs List | http://localhost:4000/jobs | Browse job openings |
| Job Details | http://localhost:4000/jobs/1 | View job details |
| Apply Form | http://localhost:4000/jobs/1/apply | Submit application |
| Design System | http://localhost:4000/debug/theme-preview | View all tokens & components |

---

## Troubleshooting

### Port 4000 already in use
```bash
# Kill any existing process on port 4000
lsof -ti:4000 | xargs kill -9 2>/dev/null || true

# Then try again
make run
```

### Can't connect to localhost:4000
1. Check the terminal for the message: `lib/main.dart is being served at http://...`
2. Copy the URL from that message (might be 127.0.0.1 or 0.0.0.0)
3. Paste it into your browser
4. If it still doesn't work, try: `http://127.0.0.1:4000`

### App not starting
```bash
# Clean everything
flutter clean

# Get dependencies
flutter pub get

# Try again
make run
```

### Dependency issues
```bash
# Update to latest Flutter
flutter upgrade

# Get latest packages
flutter pub get --upgrade

# Run
make run
```

---

## Development

### Hot Reload
- Save a file in VS Code → Auto hot reload
- Or press `r` in terminal for manual reload

### View Design System
Navigate to: **http://localhost:4000/debug/theme-preview**

This shows all design tokens and components used in the app.

### Check Code Quality
```bash
flutter analyze
```

---

## Project Structure

```
verifier-portal/code/
├── lib/
│   ├── main.dart                 (Entry point)
│   ├── core/
│   │   ├── design_system/        (Token classes, theme)
│   │   ├── navigation/           (Routing)
│   │   └── ...
│   └── features/
│       ├── jobs/                 (Jobs feature)
│       ├── debug/                (Debug screens)
│       └── ...
├── pubspec.yaml                  (Dependencies)
├── makefile                       (Commands)
└── ...
```

---

## Available Commands

```bash
# Run the app
make run

# Clean generated files
make clean

# Get help
make help
```

---

## Documentation

- **Design System**: See [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)
- **Jobs Improvements**: See [JOBS_SCREENS_IMPROVEMENTS.md](JOBS_SCREENS_IMPROVEMENTS.md)
- **Token Usage**: See [README-design.md](README-design.md)

---

## Need Help?

If you encounter any issues:

1. **Check the terminal output** - usually has clear error messages
2. **Try cleaning**: `flutter clean && flutter pub get`
3. **Check port**: `lsof -i :4000`
4. **Upgrade Flutter**: `flutter upgrade`

---

Happy coding! 🚀
