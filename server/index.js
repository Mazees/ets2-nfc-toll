const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const os = require("os");

const app = express();
app.use(cors());
const PORT = 3000;

// --- KONSOL WARNA ---
const colors = {
  reset: "\x1b[0m",
  bright: "\x1b[1m",
  dim: "\x1b[2m",
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  magenta: "\x1b[35m",
  cyan: "\x1b[36m",
  white: "\x1b[37m",
  bgGreen: "\x1b[42m",
};

// --- STATISTIK ---
let stats = {
  totalTaps: 0,
  sessionStart: new Date(),
  lastTap: null,
};

// --- BACA TUNNEL URL ---
function getTunnelUrl() {
  // Cek di folder tempat exe dijalankan (process.cwd)
  const urlFile1 = path.join(process.cwd(), "tunnel_url.txt");
  // Cek di folder script
  const urlFile2 = path.join(__dirname, "tunnel_url.txt");
  // Cek di parent folder
  const urlFile3 = path.join(__dirname, "../tunnel_url.txt");

  try {
    if (fs.existsSync(urlFile1)) {
      return fs.readFileSync(urlFile1, "utf8").trim();
    }
    if (fs.existsSync(urlFile2)) {
      return fs.readFileSync(urlFile2, "utf8").trim();
    }
    if (fs.existsSync(urlFile3)) {
      return fs.readFileSync(urlFile3, "utf8").trim();
    }
  } catch (e) {}
  return null;
}

// --- FUNGSI DASHBOARD ---
function clearConsole() {
  console.clear();
}

function printDashboard() {
  const uptime = Math.floor((new Date() - stats.sessionStart) / 1000);
  const hours = Math.floor(uptime / 3600);
  const minutes = Math.floor((uptime % 3600) / 60);
  const seconds = uptime % 60;
  const uptimeStr = `${hours.toString().padStart(2, "0")}:${minutes
    .toString()
    .padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;

  const tunnelUrl = getTunnelUrl();

  clearConsole();
  console.log(`
${colors.cyan}${colors.bright}  ============================================${
    colors.reset
  }
${colors.cyan}${colors.bright}       GTO NFC TOOLS ETS2 - SERVER${colors.reset}
${colors.cyan}${colors.bright}  ============================================${
    colors.reset
  }
${colors.dim}              Created by MAZEES${colors.reset}

${colors.green}  ============== SERVER STATUS ==============${colors.reset}
  
  ${colors.bright}[>] Tunnel URL   :${colors.reset}  ${
    tunnelUrl
      ? colors.cyan + tunnelUrl + colors.reset
      : colors.dim + "Tidak tersedia" + colors.reset
  }
  ${colors.bright}[>] URL Lokal    :${colors.reset}  ${
    colors.cyan
  }http://localhost:${PORT}${colors.reset}
  ${colors.bright}[>] Uptime       :${colors.reset}  ${
    colors.yellow
  }${uptimeStr}${colors.reset}

${colors.magenta}  ================ STATISTIK ================${colors.reset}

  ${colors.bright}[#] Total NFC Tap :${colors.reset}  ${colors.green}${
    colors.bright
  }${stats.totalTaps}${colors.reset}
  ${colors.bright}[@] Tap Terakhir  :${colors.reset}  ${
    stats.lastTap
      ? colors.yellow + stats.lastTap.toLocaleTimeString("id-ID") + colors.reset
      : colors.dim + "Belum ada" + colors.reset
  }

${colors.blue}  ================= LOG AKTIF ===============${colors.reset}
`);
}

function logTap() {
  stats.totalTaps++;
  stats.lastTap = new Date();
  printDashboard();
  console.log(
    `  ${colors.bgGreen}${colors.bright} [OK] NFC TAP #${stats.totalTaps} ${
      colors.reset
    } ${colors.green}Diterima pada ${stats.lastTap.toLocaleTimeString(
      "id-ID"
    )}${colors.reset}`
  );
  console.log(`  ${colors.dim}   +-- Trigger file ditulis${colors.reset}\n`);
}

// --- LOGIKA PENCARI IP ---
function getBestIP() {
  const interfaces = os.networkInterfaces();
  let wifiIP = null;
  let lanIP = null;

  for (const name of Object.keys(interfaces)) {
    const lowerName = name.toLowerCase();
    if (
      lowerName.includes("virtual") ||
      lowerName.includes("vmware") ||
      lowerName.includes("vethernet") ||
      lowerName.includes("wsl")
    ) {
      continue;
    }
    for (const iface of interfaces[name]) {
      if (iface.family === "IPv4" && !iface.internal) {
        if (lowerName.includes("wi-fi") || lowerName.includes("wireless")) {
          wifiIP = iface.address;
        } else {
          lanIP = iface.address;
        }
      }
    }
  }
  return wifiIP || lanIP || "localhost";
}

// --- KONFIGURASI ---
const triggerFile = path.join(process.cwd(), "trigger.txt");
const staticPath = process.cwd();
const indexPath = path.join(process.cwd(), "index.html");

app.use(express.static(staticPath));

// --- ROUTES ---
app.get("/", (req, res) => {
  res.sendFile(indexPath);
});

app.get("/pay", (req, res) => {
  logTap();
  fs.writeFile(triggerFile, "1", (err) => {
    if (err)
      console.log(
        `  ${colors.red}[X] Error: Gagal nulis trigger${colors.reset}`
      );
  });
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.send("OK");
});

// --- JALANKAN SERVER ---
app.listen(PORT, "0.0.0.0", () => {
  printDashboard();
  console.log(
    `  ${colors.green}[*] Server siap menerima koneksi...${colors.reset}`
  );
  console.log(
    `  ${colors.dim}  Buka tunnel URL di HP untuk scan NFC${colors.reset}\n`
  );

  // Update uptime setiap detik
  setInterval(() => printDashboard(), 1000);
});
