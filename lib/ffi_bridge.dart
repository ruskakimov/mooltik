import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

typedef _NativeFloodFill = Int32 Function(
  Pointer<Uint32> pixelsPointer,
  Int32 width,
  Int32 height,
  Int32 x,
  Int32 y,
  Int32 fillColor,
);

typedef _DartFloodFill = int Function(
  Pointer<Uint32> pixelsPointer,
  int width,
  int height,
  int x,
  int y,
  int fillColor,
);

class FFIBridge {
  FFIBridge() {
    final dl = _getLibrary();
    _floodFill =
        dl.lookupFunction<_NativeFloodFill, _DartFloodFill>('flood_fill');
  }

  DynamicLibrary _getLibrary() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return DynamicLibrary.open('build/test/libimage.dylib');
    }
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libimage.so');
    }
    return DynamicLibrary.process(); // iOS
  }

  late _DartFloodFill _floodFill;

  /// Floods the 4-connected color area with another color.
  /// Returns 0 if successful.
  /// Returns -1 if no changes were done.
  int floodFill(
    Uint32List pixels,
    int width,
    int height,
    int x,
    int y,
    int fillColor,
  ) {
    final pixelsPointer = malloc<Uint32>(pixels.length);
    final pointerList = pixelsPointer.asTypedList(pixels.length);
    pointerList.setAll(0, pixels);

    final exitCode = _floodFill(
      pixelsPointer,
      width,
      height,
      x,
      y,
      fillColor,
    );

    if (exitCode == 0) pixels.setAll(0, pointerList);
    malloc.free(pixelsPointer);
    return exitCode;
  }
}
