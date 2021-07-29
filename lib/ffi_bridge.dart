import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

typedef _NativeFloodFill = Void Function(Pointer<Uint32>, Int32, Int32);
typedef _DartFloodFill = void Function(Pointer<Uint32>, int, int);

class FFIBridge {
  FFIBridge() {
    final dl = Platform.isAndroid
        ? DynamicLibrary.open('libimage.so')
        : DynamicLibrary.process();

    _floodFill =
        dl.lookupFunction<_NativeFloodFill, _DartFloodFill>('flood_fill');
  }

  late _DartFloodFill _floodFill;

  void floodFill(Uint32List pixels, int fillColor) {
    final startingPointer = malloc<Uint32>(pixels.length);
    final pointerList = startingPointer.asTypedList(pixels.length);
    pointerList.setAll(0, pixels);

    _floodFill(startingPointer, pixels.length, fillColor);

    pixels.setAll(0, pointerList);

    malloc.free(startingPointer);
  }
}
