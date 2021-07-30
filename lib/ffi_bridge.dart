import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

typedef _NativeFloodFill = Void Function(
  Pointer<Uint32> pixelsPointer,
  Int32 width,
  Int32 height,
  Int32 x,
  Int32 y,
  Int32 fillColor,
);

typedef _DartFloodFill = void Function(
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

  void floodFill(
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

    _floodFill(
      pixelsPointer,
      width,
      height,
      x,
      y,
      fillColor,
    );

    pixels.setAll(0, pointerList);

    malloc.free(pixelsPointer);
  }
}
