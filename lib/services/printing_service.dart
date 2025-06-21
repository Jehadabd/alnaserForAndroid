// services/printing_service.dart
import 'dart:async'; // For Completer
import 'dart:typed_data';
// Core FFI types
// FFI utility functions and extension methods
// Changed to esc_pos_utils_plus
// Keep for Bluetooth
import 'package:alnaser/models/printer_device.dart';
import 'package:alnaser/services/settings_manager.dart';
// New import for Wi-Fi/LAN printing
// Import for Windows API calls

abstract class PrintingService {
  final SettingsManager _settingsManager = SettingsManager();

  // Method to get the default printer from settings
  Future<PrinterDevice?> getDefaultPrinter() async {
    return await _settingsManager.getDefaultPrinter();
  }

  // --- Wi-Fi/LAN Printers ---
  Future<void> printWithWifiPrinter(String ipAddress, List<int> commands, {int port = 9100});

  // --- Bluetooth Printers ---
  Future<List<PrinterDevice>> findBluetoothPrinters();
  Future<void> printWithBluetoothPrinter(String macAddress, List<int> commands);

  // Abstract method for general printing (platform-specific implementation)
  Future<void> printData(Uint8List dataToPrint, {List<int>? escPosCommands, PrinterDevice? printerDevice});

  // Abstract method for finding system printers (Windows-specific)
  Future<List<PrinterDevice>> findSystemPrinters();
} 