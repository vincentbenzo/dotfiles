#!/usr/bin/env python3
"""Read or set display brightness via macOS DisplayServices private framework."""
import ctypes
import sys

_ds = ctypes.cdll.LoadLibrary("/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices")
_cg = ctypes.cdll.LoadLibrary("/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics")
_cg.CGMainDisplayID.restype = ctypes.c_uint
_ds.DisplayServicesGetBrightness.argtypes = [ctypes.c_uint, ctypes.POINTER(ctypes.c_float)]
_ds.DisplayServicesGetBrightness.restype = ctypes.c_int
_ds.DisplayServicesSetBrightness.argtypes = [ctypes.c_uint, ctypes.c_float]
_ds.DisplayServicesSetBrightness.restype = ctypes.c_int

display = _cg.CGMainDisplayID()

if len(sys.argv) > 1:
    # Set brightness (0-100)
    val = max(0, min(100, int(sys.argv[1])))
    _ds.DisplayServicesSetBrightness(display, val / 100.0)
    print(val)
else:
    # Get brightness (prints 0-100)
    b = ctypes.c_float()
    _ds.DisplayServicesGetBrightness(display, ctypes.byref(b))
    print(int(b.value * 100))
