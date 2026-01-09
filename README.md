# GTO NFC Tools ETS2

> Trigger toll payment in Euro Truck Simulator 2 using NFC from your Android phone!

![Platform](https://img.shields.io/badge/Platform-Windows-blue)
![License](https://img.shields.io/badge/License-Free%20for%20Personal%20Use-green)

## Features

- **NFC Trigger** - Use any NFC card/tag to pay toll
( Disclaimer: This feature doesn't affect your card balance. Your card only serves as a trigger. )
- **Remote Access** - Control from phone via internet (Ngrok tunnel)
- **Real-time** - Instant response when NFC is tapped
- **Auto Keypress** - Automatically presses Enter in game
- **Dashboard** - Live server status with tap statistics

## Requirements

### PC

- Windows 10/11 (64-bit)
- Internet connection

### Phone

- Android with NFC support
- **Chrome browser** (required - other browsers don't support Web NFC)
- Internet connection
- NFC Supported Card

## Quick Start

### 1. Download & Setup Ngrok

1. Create free account at [ngrok.com](https://ngrok.com)
2. Get your Auth Token from [dashboard](https://dashboard.ngrok.com/get-started/your-authtoken)

### 2. Run the Tool

1. Download the latest release from [GitHub](https://github.com/Mazees/ets2-nfc-toll/releases)
2. Extract and run `run.bat`
3. Enter your Ngrok token when prompted (first time only)
4. Wait for the tunnel URL

### 3. Connect Your Phone

1. Open Chrome on your Android phone
2. Navigate to the ngrok URL shown on PC
3. Tap screen to start
4. Hold your NFC card to the back of your phone
5. Toll paid!

## Project Structure

```
ets2-toll-server/
├── server/
│   └── index.js        # Express server with dashboard
├── build/              # Distribution folder
│   ├── run.bat         # Main launcher
│   ├── server.exe      # Bundled server
│   ├── ngrok.exe       # Tunnel tool
│   ├── autokey.exe     # Keyboard automation
│   └── index.html      # NFC web interface
├── run.bat             # Development launcher
├── build.bat           # Build script
├── autokey.ahk         # AutoHotkey source
└── index.html          # Frontend source
```

## Development

### 1. Clone the Project

```bash
# Clone the repository
git clone https://github.com/Mazees/ets2-nfc-toll.git

# Enter the directory
cd ets2-nfc-toll

# Install dependencies
npm install
```

### 2. Prerequisites

- **Node.js**: Version 18 or higher.
- **AutoHotkey**: Required only if you want to modify or recompile the automation script.
- **pkg**: Global package for bundling the server (`npm install -g pkg`).

### 3. Compiling AutoHotkey Script

If you modify `autokey.ahk`, you must recompile it to `autokey.exe`:

1.  Install [AutoHotkey](https://www.autohotkey.com/).
2.  Open AutoHotkey.
3.  Select **Compile Script**, select file `autokey.ahk` and save with name `autokey.exe`.
4.  Place `autokey.exe` in root project.

### 4. Build for Distribution

To create the portable version in the `build/` folder:

```bash
build.bat
```

This script will:

- Clear the `build/` directory.
- Bundle `server/index.js` into `server.exe`.
- Copy all necessary files (`ngrok.exe`, `autokey.exe`, `index.html`, etc.) into the `build/` folder.

### 5. Running server in Development Mode

```bash
# Start the server directly
node server/index.js
```

## Tech Stack

- **Backend**: Node.js, Express.js
- **Tunnel**: Ngrok
- **Automation**: AutoHotkey
- **Frontend**: HTML5, Web NFC API
- **Bundler**: pkg

## Troubleshooting

| Problem            | Solution                                                            |
| ------------------ | ------------------------------------------------------------------- |
| Link not appearing | Check Ngrok token, delete `ngrok_token.txt` and retry               |
| NFC not detected   | Use Chrome browser, enable NFC in phone settings                    |
| Toll not paying    | Make sure ETS2 window is focused, check autokey.exe in Task Manager |
| Trigger error      | Run as Administrator                                                |

## License

This project is licensed under the **MIT Non-Commercial License**.

Copyright (c) 2026 MAZEES

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, and distribute copies of the Software, but **strictly for non-commercial purposes only**.

See the [LICENSE](LICENSE) file for more details.

## Credits

**Developer**: MAZEES

**Powered by**:

- [Express.js](https://expressjs.com/) - Web framework
- [Ngrok](https://ngrok.com/) - Secure tunnels
- [AutoHotkey](https://www.autohotkey.com/) - Automation
- [pkg](https://github.com/vercel/pkg) - Node.js bundler

---

<p align="center">
  Made with love for ETS2 community
</p>
