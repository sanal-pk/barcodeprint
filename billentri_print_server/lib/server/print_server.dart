// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class PrintItem {
  final String companyName;
  final String itemName;
  final String barcode;
  final double price;
  final String currency;

  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double rowGap;
  final double columnGap;
  final int barcodeRow;
  final int decimalPlaces;

  // Font settings
  final String companyFont;
  final int companyFontSize;
  final String itemFont;
  final int itemFontSize;
  final String barcodeTextFont;
  final int barcodeTextFontSize;
  final String priceFont;
  final int priceFontSize;

  PrintItem({
    required this.companyName,
    required this.itemName,
    required this.barcode,
    required this.price,
    required this.currency,
    this.marginLeft = 0.0,
    this.marginTop = 0.0,
    this.marginRight = 0.0,
    this.marginBottom = 0.0,
    this.rowGap = 0.0,
    this.columnGap = 0.0,
    this.barcodeRow = 1,
    this.decimalPlaces = 3,
    this.companyFont = "1",
    this.companyFontSize = 1,
    this.itemFont = "2",
    this.itemFontSize = 1,
    this.barcodeTextFont = "2",
    this.barcodeTextFontSize = 1,
    this.priceFont = "2",
    this.priceFontSize = 1,
  });

  factory PrintItem.fromJson(Map<String, dynamic> json) {
    return PrintItem(
      companyName: json['companyName'] ?? '',
      itemName: json['itemName'] ?? '',
      barcode: json['barcode'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      marginLeft: (json['marginLeft'] ?? 0).toDouble(),
      marginTop: (json['marginTop'] ?? 0).toDouble(),
      marginRight: (json['marginRight'] ?? 0).toDouble(),
      marginBottom: (json['marginBottom'] ?? 0).toDouble(),
      rowGap: (json['rowGap'] ?? 0).toDouble(),
      columnGap: (json['columnGap'] ?? 0).toDouble(),
      barcodeRow: json['barcodeRow'] ?? 1,
      decimalPlaces: json['decimalPlaces'] ?? 3,
      companyFont: json['companyFont']?.toString() ?? "1",
      companyFontSize: json['companyFontSize'] ?? 1,
      itemFont: json['itemFont']?.toString() ?? "2",
      itemFontSize: json['itemFontSize'] ?? 1,
      barcodeTextFont: json['barcodeTextFont']?.toString() ?? "2",
      barcodeTextFontSize: json['barcodeTextFontSize'] ?? 1,
      priceFont: json['priceFont']?.toString() ?? "2",
      priceFontSize: json['priceFontSize'] ?? 1,
    );
  }
}

// ── Printer Profiles ────────────────────────────────────────────────────────

class PrinterProfile {
  final String id;
  final String displayName;
  final String sizeCmd;
  final String gapCmd;
  final int labelsPerRow;
  final int singleLabelWidthDots;
  final int labelHeightDots;
  final int density;
  final int speed;

  const PrinterProfile({
    required this.id,
    required this.displayName,
    required this.sizeCmd,
    required this.gapCmd,
    this.labelsPerRow = 1,
    required this.singleLabelWidthDots,
    required this.labelHeightDots,
    this.density = 8,
    this.speed = 4,
  });

  static PrinterProfile? fromId(String id) {
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static const List<PrinterProfile> all = [
    tscTtp244Pro2Up,
    tscTtp244Pro1Up,
    tvseZenpert4T520_50x25_1Up,
    tvseZenpert4T520_38x25_1Up,
    tvseZenpert4T520_50x30_1Up,
    tvseZenpert4T520_50x25_2Up,
    tvseZenpert4T520_100x50_1Up,
    argoxOs214Plus_50x25_1Up,
    xprinterXp420b_50x25_1Up,
    godexEz130_50x25_1Up,
    generic_58x40_1Up,
    generic_80x50_1Up,
  ];

  // ── TSC ──────────────────────────────────────────────────────────────────
  static const tscTtp244Pro2Up = PrinterProfile(
    id: 'TSC_TTP244_2UP',
    displayName: 'TSC TTP-244 Pro (77.6×25 mm, 2-Up)',
    sizeCmd: 'SIZE 77.6 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    labelsPerRow: 2,
    singleLabelWidthDots: 310,
    labelHeightDots: 200,
  );

  static const tscTtp244Pro1Up = PrinterProfile(
    id: 'TSC_TTP244_1UP',
    displayName: 'TSC TTP-244 Pro (38×25 mm, 1-Up)',
    sizeCmd: 'SIZE 38 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 304,
    labelHeightDots: 200,
  );

  // ── TVSE ZENPERT 4T520 ───────────────────────────────────────────────────
  static const tvseZenpert4T520_50x25_1Up = PrinterProfile(
    id: 'TVSE_4T520_50x25_1UP',
    displayName: 'TVSE ZENPERT 4T520 (50×25 mm, 1-Up)',
    sizeCmd: 'SIZE 50 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 400,
    labelHeightDots: 200,
  );

  static const tvseZenpert4T520_38x25_1Up = PrinterProfile(
    id: 'TVSE_4T520_38x25_1UP',
    displayName: 'TVSE ZENPERT 4T520 (38×25 mm, 1-Up)',
    sizeCmd: 'SIZE 38 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 304,
    labelHeightDots: 200,
  );

  static const tvseZenpert4T520_50x30_1Up = PrinterProfile(
    id: 'TVSE_4T520_50x30_1UP',
    displayName: 'TVSE ZENPERT 4T520 (50×30 mm, 1-Up)',
    sizeCmd: 'SIZE 50 mm,30 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 400,
    labelHeightDots: 240,
  );

  static const tvseZenpert4T520_50x25_2Up = PrinterProfile(
    id: 'TVSE_4T520_50x25_2UP',
    displayName: 'TVSE ZENPERT 4T520 (50×25 mm, 2-Up)',
    sizeCmd: 'SIZE 100 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    labelsPerRow: 2,
    singleLabelWidthDots: 400,
    labelHeightDots: 200,
  );

  static const tvseZenpert4T520_100x50_1Up = PrinterProfile(
    id: 'TVSE_4T520_100x50_1UP',
    displayName: 'TVSE ZENPERT 4T520 (100×50 mm, 1-Up)',
    sizeCmd: 'SIZE 100 mm,50 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 800,
    labelHeightDots: 400,
  );

  // ── Argox ─────────────────────────────────────────────────────────────────
  static const argoxOs214Plus_50x25_1Up = PrinterProfile(
    id: 'ARGOX_OS214_50x25_1UP',
    displayName: 'Argox OS-214 Plus (50×25 mm, 1-Up)',
    sizeCmd: 'SIZE 50 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 400,
    labelHeightDots: 200,
  );

  // ── Xprinter ──────────────────────────────────────────────────────────────
  static const xprinterXp420b_50x25_1Up = PrinterProfile(
    id: 'XPRINTER_XP420B_50x25_1UP',
    displayName: 'Xprinter XP-420B (50×25 mm, 1-Up)',
    sizeCmd: 'SIZE 50 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 400,
    labelHeightDots: 200,
  );

  // ── Godex ─────────────────────────────────────────────────────────────────
  static const godexEz130_50x25_1Up = PrinterProfile(
    id: 'GODEX_EZ130_50x25_1UP',
    displayName: 'Godex EZ130 (50×25 mm, 1-Up)',
    sizeCmd: 'SIZE 50 mm,25 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 400,
    labelHeightDots: 200,
  );

  // ── Generic ───────────────────────────────────────────────────────────────
  static const generic_58x40_1Up = PrinterProfile(
    id: 'GENERIC_58x40_1UP',
    displayName: 'Generic (58×40 mm, 1-Up)',
    sizeCmd: 'SIZE 58 mm,40 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 464,
    labelHeightDots: 320,
  );

  static const generic_80x50_1Up = PrinterProfile(
    id: 'GENERIC_80x50_1UP',
    displayName: 'Generic (80×50 mm, 1-Up)',
    sizeCmd: 'SIZE 80 mm,50 mm',
    gapCmd: 'GAP 3 mm,0',
    singleLabelWidthDots: 640,
    labelHeightDots: 400,
  );
}

class PrintServer {
  HttpServer? _server;
  final int port;

  String? localIp;

  PrintServer({this.port = 5050});

  static Future<String> getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      // 1. First preference: Wi-Fi / Wireless / WLAN adapter
      for (var interface in interfaces) {
        final name = interface.name.toLowerCase();
        if (name.contains('wi-fi') ||
            name.contains('wifi') ||
            name.contains('wireless') ||
            name.contains('wlan')) {
          for (var addr in interface.addresses) {
            final ip = addr.address;
            if (!ip.startsWith('169.254.') && !ip.startsWith('127.')) {
              return ip;
            }
          }
        }
      }

      // 2. Second preference: Physical Ethernet / LAN adapter (skip virtual / bridge adapters)
      for (var interface in interfaces) {
        final name = interface.name.toLowerCase();
        if (name.contains('virtual') ||
            name.contains('vmware') ||
            name.contains('vbox') ||
            name.contains('vethernet') ||
            name.contains('wsl') ||
            name.contains('hyper-v') ||
            name.contains('bluetooth') ||
            name.contains('tap') ||
            name.contains('npcap')) {
          continue;
        }
        for (var addr in interface.addresses) {
          final ip = addr.address;
          if (ip.startsWith('169.254.') || ip.startsWith('127.')) continue;
          // Deprioritize unconfigured/gateway .1
          if (!ip.endsWith('.1')) {
            return ip;
          }
        }
      }

      // 3. Third preference: Any 192.168.x.x or 10.x.x.x
      for (var interface in interfaces) {
        final name = interface.name.toLowerCase();
        if (name.contains('vmware') || name.contains('vbox') || name.contains('wsl')) continue;
        for (var addr in interface.addresses) {
          final ip = addr.address;
          if (ip.startsWith('192.168.') || ip.startsWith('10.')) {
            return ip;
          }
        }
      }

      // 4. Fallback: Any IPv4 address found
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          return addr.address;
        }
      }
    } catch (e) {
      print('Warning: Could not get local IP address: $e');
    }
    return '127.0.0.1';
  }

  Future<void> start() async {
    final router = Router();

    // Health check API
    router.get('/test', (Request request) {
      final html = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>BillEntri Print Server – Connection Successful</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', system-ui, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #0a0f1e;
      background-image:
        radial-gradient(ellipse 80% 60% at 50% -10%, rgba(1,111,66,0.35) 0%, transparent 70%),
        radial-gradient(ellipse 50% 40% at 80% 80%, rgba(0,200,120,0.12) 0%, transparent 60%);
      color: #e2e8f0;
      padding: 24px;
    }

    .card {
      background: rgba(255,255,255,0.04);
      border: 1px solid rgba(255,255,255,0.08);
      backdrop-filter: blur(24px);
      border-radius: 24px;
      padding: 56px 48px;
      max-width: 520px;
      width: 100%;
      text-align: center;
      box-shadow:
        0 0 0 1px rgba(1,111,66,0.15),
        0 32px 64px rgba(0,0,0,0.5),
        0 0 80px rgba(1,111,66,0.08);
      animation: fadeUp 0.6s cubic-bezier(0.16,1,0.3,1) both;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Animated ring + checkmark ── */
    .check-wrap {
      position: relative;
      width: 96px;
      height: 96px;
      margin: 0 auto 32px;
    }

    .check-ring {
      width: 96px;
      height: 96px;
      border-radius: 50%;
      border: 3px solid rgba(1,111,66,0.25);
      position: absolute;
      inset: 0;
      animation: pulse-ring 2.4s ease-out infinite;
    }

    @keyframes pulse-ring {
      0%   { transform: scale(1);   opacity: 0.6; }
      60%  { transform: scale(1.5); opacity: 0; }
      100% { transform: scale(1.5); opacity: 0; }
    }

    .check-circle {
      width: 96px;
      height: 96px;
      border-radius: 50%;
      background: linear-gradient(135deg, #016F42 0%, #00c97a 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      box-shadow: 0 0 32px rgba(0,201,122,0.4), 0 8px 24px rgba(0,0,0,0.3);
      animation: pop 0.5s 0.2s cubic-bezier(0.34,1.56,0.64,1) both;
    }

    @keyframes pop {
      from { transform: scale(0.5); opacity: 0; }
      to   { transform: scale(1);   opacity: 1; }
    }

    .check-svg {
      width: 44px;
      height: 44px;
      stroke: #fff;
      stroke-width: 3;
      fill: none;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .check-path {
      stroke-dasharray: 52;
      stroke-dashoffset: 52;
      animation: draw 0.5s 0.55s ease forwards;
    }

    @keyframes draw {
      to { stroke-dashoffset: 0; }
    }

    /* ── Brand ── */
    .brand {
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 0.12em;
      text-transform: uppercase;
      color: #00c97a;
      margin-bottom: 12px;
    }

    h1 {
      font-size: 26px;
      font-weight: 700;
      color: #f1f5f9;
      line-height: 1.2;
      margin-bottom: 12px;
    }

    .subtitle {
      font-size: 15px;
      color: #94a3b8;
      line-height: 1.6;
      margin-bottom: 36px;
    }

    /* ── Status pills ── */
    .pills {
      display: flex;
      gap: 12px;
      justify-content: center;
      flex-wrap: wrap;
      margin-bottom: 32px;
    }

    .pill {
      display: flex;
      align-items: center;
      gap: 7px;
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(255,255,255,0.08);
      border-radius: 100px;
      padding: 7px 16px;
      font-size: 13px;
      font-weight: 500;
      color: #cbd5e1;
    }

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #00c97a;
      box-shadow: 0 0 6px #00c97a;
      animation: blink 2s ease-in-out infinite;
    }

    @keyframes blink {
      0%, 100% { opacity: 1; }
      50%       { opacity: 0.3; }
    }

    /* ── Server info box ── */
    .info-box {
      background: rgba(1,111,66,0.08);
      border: 1px solid rgba(1,111,66,0.2);
      border-radius: 12px;
      padding: 16px 20px;
      text-align: left;
      font-size: 13px;
      color: #94a3b8;
      line-height: 1.8;
    }

    .info-box span { color: #e2e8f0; font-weight: 500; }

    /* ── Footer ── */
    .footer {
      margin-top: 32px;
      font-size: 12px;
      color: #475569;
    }

    @media (max-width: 480px) {
      .card { padding: 40px 24px; }
      h1 { font-size: 22px; }
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="check-wrap">
      <div class="check-ring"></div>
      <div class="check-circle">
        <svg class="check-svg" viewBox="0 0 52 52">
          <polyline class="check-path" points="14,27 22,35 38,17" />
        </svg>
      </div>
    </div>

    <div class="brand">BillEntri Print Server</div>
    <h1>Connection Successful</h1>
    <p class="subtitle">Your print server is online and ready to receive print jobs from the BillEntri app.</p>

    <div class="pills">
      <div class="pill"><span class="dot"></span> Server Online</div>
      <div class="pill"><span class="dot"></span> API Reachable</div>
    </div>

   <div class="footer">Scan the QR code in the BillEntri Print Server dashboard to connect your device.</div>
  </div>
</body>
</html>''';

      return Response.ok(
        html,
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    });

    // Profiles API
    router.get('/profiles', (Request request) {
      final list = PrinterProfile.all
          .map((p) => {'id': p.id, 'displayName': p.displayName})
          .toList();
      return Response.ok(
        jsonEncode(list),
        headers: {'content-type': 'application/json'},
      );
    });

    // Installed Windows Printers API
    router.get('/printers', (Request request) async {
      if (!Platform.isWindows) {
        return Response.ok(
          jsonEncode({'os': Platform.operatingSystem, 'printers': []}),
          headers: {'content-type': 'application/json'},
        );
      }
      try {
        final result = await Process.run('powershell', [
          '-NoProfile',
          '-NonInteractive',
          '-Command',
          'Get-CimInstance Win32_Printer | Select-Object Name, ShareName, PortName, Default, WorkOffline, PrinterStatus | ConvertTo-Json',
        ]);
        dynamic list = [];
        if (result.stdout.toString().trim().isNotEmpty) {
          try {
            list = jsonDecode(result.stdout.toString().trim());
            if (list is Map) list = [list];
          } catch (_) {}
        }
        return Response.ok(
          jsonEncode({'success': true, 'printers': list}),
          headers: {'content-type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'success': false, 'error': e.toString()}),
          headers: {'content-type': 'application/json'},
        );
      }
    });

    // Bulk print API
    router.post('/print-bulk', (Request request) async {
      try {
        final body = await request.readAsString();
        final decoded = jsonDecode(body);

        List<dynamic> jsonList;
        PrinterProfile profile = PrinterProfile.tscTtp244Pro2Up;

        if (decoded is List) {
          // Backward-compatible: bare array defaults to TSC 2-up
          jsonList = decoded;
        } else if (decoded is Map) {
          jsonList = (decoded['items'] as List<dynamic>?) ?? [];
          final profileId = decoded['profile'] as String? ?? '';
          profile =
              PrinterProfile.fromId(profileId) ??
              PrinterProfile.tscTtp244Pro2Up;
        } else {
          return Response.badRequest(
            body: jsonEncode({'error': 'Invalid request body'}),
            headers: {'content-type': 'application/json'},
          );
        }

        final items = jsonList
            .map((e) => PrintItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        String tspl =
            '${profile.sizeCmd}\r\n'
            '${profile.gapCmd}\r\n'
            'DENSITY ${profile.density}\r\n'
            'SPEED ${profile.speed}\r\n'
            'DIRECTION 1\r\n'
            'REFERENCE 0,0\r\n';

        if (profile.labelsPerRow >= 2) {
          for (int i = 0; i < items.length; i += 2) {
            final left = items[i];
            final right = (i + 1 < items.length) ? items[i + 1] : null;

            tspl += 'CLS\r\n';
            tspl += generateLabelTspl(left, 0, profile);

            if (right != null) {
              final rightOffsetX =
                  profile.singleLabelWidthDots + right.columnGap.toInt();
              tspl += generateLabelTspl(right, rightOffsetX, profile);
            }

            tspl += 'PRINT 1,1\r\n';
          }
        } else {
          for (final item in items) {
            tspl += 'CLS\r\n';
            tspl += generateLabelTspl(item, 0, profile);
            tspl += 'PRINT 1,1\r\n';
          }
        }

        print("Printing \${items.length} labels");
        final printResult = await sendToPrinter(tspl);

        // We fetch the latest console output directly to the response for easy debugging via curl
        return Response.ok(
          jsonEncode({
            'success': printResult['exitCode'] == 0,
            'printed': items.length,
            'exitCode': printResult['exitCode'],
            'stdout': printResult['stdout'],
            'stderr': printResult['stderr'],
            'message': printResult['exitCode'] == 0
                ? 'Print command sent successfully'
                : 'Print command failed on Windows',
          }),
          headers: {'content-type': 'application/json'},
        );
      } catch (error) {
        print(error);
        return Response.internalServerError(
          body: jsonEncode({'success': false, 'error': error.toString()}),
          headers: {'content-type': 'application/json'},
        );
      }
    });

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _server = await io.serve(handler, '0.0.0.0', port);
    localIp = await getLocalIpAddress();
    print('BillEntri Print Server Started');
    print('Dashboard / Setup : http://$localIp:$port');
  }

  Future<void> stop() async {
    await _server?.close();
  }

  // --- TSPL HELPER FUNCTIONS ---
  int getCharWidth(String fontSize, int fontSizeMultiplier) {
    int baseWidth = 8;
    if (fontSize == "6") baseWidth = 14;
    if (fontSize == "3") baseWidth = 16;
    if (fontSize == "2") baseWidth = 11;
    return baseWidth * fontSizeMultiplier;
  }

  int getCenteredX(
    String text,
    int centerX,
    String fontSize,
    int fontSizeMultiplier,
  ) {
    final textWidth = text.length * getCharWidth(fontSize, fontSizeMultiplier);
    return (centerX - textWidth / 2).floor();
  }

  String generateLabelTspl(PrintItem item, int startX, PrinterProfile profile) {
    StringBuffer buf = StringBuffer();
    final halfWidth = profile.singleLabelWidthDots ~/ 2;
    final centerX = startX + halfWidth + item.marginLeft.toInt();
    final maxContentWidth = profile.singleLabelWidthDots - 30;
    // Barcode height scales with label height (30% of label, clamped 40–120 dots)
    final barcodeHeight = (profile.labelHeightDots * 0.30).round().clamp(
      40,
      120,
    );
    // Character limits scale with usable label width
    final companyCharWidth = getCharWidth(item.companyFont, item.companyFontSize);
    final companyMaxChars = (maxContentWidth / (companyCharWidth > 0 ? companyCharWidth : 8)).floor().clamp(16, 80);
    final itemCharWidth = getCharWidth(item.itemFont, item.itemFontSize);
    final itemMaxChars = (maxContentWidth / (itemCharWidth > 0 ? itemCharWidth : 11)).floor().clamp(16, 80);
    int currentY = 15 + item.marginTop.toInt();

    // 1. Company Name (up to 2 lines, small & clean without letter-spacing/blur)
    final companyLines = splitText(item.companyName, companyMaxChars);
    for (var line in companyLines) {
      int compX = getCenteredX(
        line,
        centerX,
        item.companyFont,
        item.companyFontSize,
      );
      buf.write(
        'TEXT $compX,$currentY,"${item.companyFont}",0,${item.companyFontSize},${item.companyFontSize},"$line"\r\n',
      );
      currentY += 15 + item.rowGap.toInt();
    }

    // 2. Item Name (up to 2 lines)
    final nameLines = splitText(item.itemName, itemMaxChars);
    for (var line in nameLines) {
      buf.write(
        'TEXT ${getCenteredX(line, centerX, item.itemFont, item.itemFontSize)},$currentY,"${item.itemFont}",0,${item.itemFontSize},${item.itemFontSize},"$line"\r\n',
      );
      currentY += 22 + item.rowGap.toInt();
    }

    // 3. Barcode – height & bar widths scale with label dimensions
    int digitsCount = 0, otherCount = 0;
    for (int i = 0; i < item.barcode.length; i++) {
      int code = item.barcode.codeUnitAt(i);
      if (code >= 48 && code <= 57)
        digitsCount++;
      else
        otherCount++;
    }
    // Subset C encodes 2 digits per char.
    int estimatedChars128 = (digitsCount ~/ 2) + (digitsCount % 2) + otherCount;
    int estWidthNarrow1 = 11 * (estimatedChars128 + 2) + 13;

    // Use wide bars if they fit within the usable content width
    int narrow = (estWidthNarrow1 * 2 < maxContentWidth) ? 2 : 1;
    int wide = narrow == 1 ? 2 : 3;

    int estWidth = estWidthNarrow1 * narrow;
    int barcodeX = centerX - (estWidth ~/ 2);
    if (barcodeX < startX + 15)
      barcodeX = startX + 15; // Left padding constraint

    currentY += 8; // Extra padding before barcode
    buf.write(
      'BARCODE $barcodeX,$currentY,"128",$barcodeHeight,0,0,$narrow,$wide,"${item.barcode}"\r\n',
    );
    currentY += barcodeHeight + 10;

    // 4. Barcode Text
    buf.write(
      'TEXT ${getCenteredX(item.barcode, centerX, item.barcodeTextFont, item.barcodeTextFontSize)},$currentY,"${item.barcodeTextFont}",0,${item.barcodeTextFontSize},${item.barcodeTextFontSize},"${item.barcode}"\r\n',
    );
    currentY += 18 + item.rowGap.toInt();

    // 5. Price (Font 2, Bold)
    final currency = item.currency.replaceAll('₹', 'Rs.');
    String currencyPrefix = currency.endsWith(':') ? currency : '$currency:';
    if (currency.isEmpty) currencyPrefix = '';

    // Use dynamic decimal places (defaults to 3)
    final priceStr =
        '$currencyPrefix${item.price.toStringAsFixed(item.decimalPlaces)}';
    int priceX = getCenteredX(
      priceStr,
      centerX,
      item.priceFont,
      item.priceFontSize,
    );
    buf.write(
      'TEXT $priceX,$currentY,"${item.priceFont}",0,${item.priceFontSize},${item.priceFontSize},"$priceStr"\r\n',
    );
    buf.write(
      'TEXT ${priceX + 1},$currentY,"${item.priceFont}",0,${item.priceFontSize},${item.priceFontSize},"$priceStr"\r\n',
    ); // Bold effect

    return buf.toString();
  }

  List<String> splitText(String text, int maxLength) {
    if (text.isEmpty) return [];
    if (text.length <= maxLength) return [text];

    int splitIndex = text.lastIndexOf(" ", maxLength);
    if (splitIndex == -1 || splitIndex == 0) splitIndex = maxLength;

    final line1 = text.substring(0, splitIndex).trim();
    String line2 = text.substring(splitIndex).trim();

    // Add ellipsis if line 2 overflows, ensuring max 2 lines
    if (line2.length > maxLength) {
      line2 = "${line2.substring(0, maxLength - 2).trimRight()}..";
    }
    return [line1, line2];
  }

  Future<Map<String, dynamic>> sendToPrinter(String tspl) async {
    if (!Platform.isWindows) {
      print("Warning: Skipping physical print because OS is not Windows.");
      print("TSPL Generated:\n$tspl");
      return {'exitCode': 0, 'stdout': 'Skipped (Not Windows)', 'stderr': ''};
    }

    try {
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}\\temp_label_${DateTime.now().millisecondsSinceEpoch}.tspl',
      );
      await tempFile.writeAsBytes(latin1.encode(tspl));

      // 1. Primary: Direct Windows Spooler Raw Print via PowerShell (no sharing required)
      const psScript = r'''
$bytes = [System.IO.File]::ReadAllBytes($args[0])
$code = @"
using System;
using System.Runtime.InteropServices;
public class RawPrint {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
    public class DOCINFOA {
        [MarshalAs(UnmanagedType.LPStr)] public string pDocName;
        [MarshalAs(UnmanagedType.LPStr)] public string pOutputFile;
        [MarshalAs(UnmanagedType.LPStr)] public string pDataType;
    }
    [DllImport("winspool.Drv", EntryPoint = "OpenPrinterA", SetLastError = true, CharSet = CharSet.Ansi, ExactSpelling = true)]
    public static extern bool OpenPrinter(string p, out IntPtr h, IntPtr d);
    [DllImport("winspool.Drv", EntryPoint = "ClosePrinter", SetLastError = true)]
    public static extern bool ClosePrinter(IntPtr h);
    [DllImport("winspool.Drv", EntryPoint = "StartDocPrinterA", SetLastError = true, CharSet = CharSet.Ansi)]
    public static extern bool StartDocPrinter(IntPtr h, int l, [In, MarshalAs(UnmanagedType.LPStruct)] DOCINFOA d);
    [DllImport("winspool.Drv", EntryPoint = "EndDocPrinter", SetLastError = true)]
    public static extern bool EndDocPrinter(IntPtr h);
    [DllImport("winspool.Drv", EntryPoint = "StartPagePrinter", SetLastError = true)]
    public static extern bool StartPagePrinter(IntPtr h);
    [DllImport("winspool.Drv", EntryPoint = "EndPagePrinter", SetLastError = true)]
    public static extern bool EndPagePrinter(IntPtr h);
    [DllImport("winspool.Drv", EntryPoint = "WritePrinter", SetLastError = true)]
    public static extern bool WritePrinter(IntPtr h, IntPtr b, int c, out int w);
    public static bool Send(string name, byte[] data) {
        IntPtr p = Marshal.AllocCoTaskMem(data.Length);
        Marshal.Copy(data, 0, p, data.Length);
        IntPtr h;
        DOCINFOA d = new DOCINFOA { pDocName = "BillEntri", pDataType = "RAW" };
        bool ok = false;
        if (OpenPrinter(name, out h, IntPtr.Zero)) {
            if (StartDocPrinter(h, 1, d)) {
                if (StartPagePrinter(h)) {
                    int w;
                    ok = WritePrinter(h, p, data.Length, out w);
                    EndPagePrinter(h);
                }
                EndDocPrinter(h);
            }
            ClosePrinter(h);
        }
        Marshal.FreeCoTaskMem(p);
        return ok;
    }
}
"@
Add-Type -TypeDefinition $code -Language CSharp
$printers = Get-CimInstance Win32_Printer
$target = $printers | Where-Object { $_.ShareName -ieq 'barcode' } | Select-Object -First 1
if (-not $target) {
    $target = $printers | Where-Object { $_.Name -match '(?i)barcode|tsc|ttp|tvse|zenpert|4t520|xprinter|argox|godex|label|pos|zebra|zdesigner|honeywell|citizen|dymo|bixolon|thermal' } | Select-Object -First 1
}
if (-not $target) {
    $target = $printers | Where-Object { $_.Default -eq $true } | Select-Object -First 1
}
if (-not $target) {
    $target = $printers | Where-Object { $_.Name -notmatch '(?i)pdf|xps|onenote|fax|microsoft' } | Select-Object -First 1
}
if ($target) {
    $success = [RawPrint]::Send($target.Name, $bytes)
    if ($success) {
        Write-Output "Printed directly to $($target.Name) (Port: $($target.PortName))"
        exit 0
    } else {
        $err = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
        Write-Error "Failed writing raw bytes to $($target.Name) (Win32 Error: $err)"
        exit 2
    }
}
Write-Error "No physical printer found. Installed printers: $(($printers | ForEach-Object { $_.Name }) -join ', ')"
exit 1
''';

      ProcessResult result = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        psScript,
        tempFile.path,
      ]);

      if (result.exitCode != 0) {
        // 2. Secondary fallback: try copy /b to shared printer network paths
        final targets = [
          r'\\127.0.0.1\barcode',
          r'\\localhost\barcode',
        ];
        for (final target in targets) {
          result = await Process.run('cmd', [
            '/c',
            'copy',
            '/b',
            tempFile.path,
            target,
          ]);
          if (result.exitCode == 0) break;
        }
      }

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      print('Print command exit code: ${result.exitCode}');
      print('Print stdout: ${result.stdout}');
      if (result.stderr.toString().isNotEmpty) {
        print('Print stderr: ${result.stderr}');
      }
      return {
        'exitCode': result.exitCode,
        'stdout': result.stdout.toString().trim(),
        'stderr': result.stderr.toString().trim(),
      };
    } catch (e) {
      print('Printer error: $e');
      return {'exitCode': -1, 'stdout': '', 'stderr': e.toString()};
    }
  }
}
