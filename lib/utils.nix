# Design System - Utility Functions
# lib/utils.nix
#
# Pure helper functions used throughout the design system

{ lib }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Convert hex color to RGB components
  # hexToRgb "#ff6b6b" -> { r = 255; g = 107; b = 107; }
  hexToRgb = hex:
    let
      cleanHex = lib.removePrefix "#" hex;
      # Ensure we have 6 characters
      normalizedHex =
        if builtins.stringLength cleanHex == 3
        then # Convert 3-char hex to 6-char: "f0a" -> "ff00aa"
          (builtins.substring 0 1 cleanHex) + (builtins.substring 0 1 cleanHex) +
          (builtins.substring 1 1 cleanHex) + (builtins.substring 1 1 cleanHex) +
          (builtins.substring 2 1 cleanHex) + (builtins.substring 2 1 cleanHex)
        else cleanHex;

      # Helper function to convert hex digit to number
      hexDigitToInt = digit:
        if digit == "0" then 0 else if digit == "1" then 1 else if digit == "2" then 2
        else if digit == "3" then 3 else if digit == "4" then 4 else if digit == "5" then 5
        else if digit == "6" then 6 else if digit == "7" then 7 else if digit == "8" then 8
        else if digit == "9" then 9 else if digit == "a" || digit == "A" then 10
        else if digit == "b" || digit == "B" then 11 else if digit == "c" || digit == "C" then 12
        else if digit == "d" || digit == "D" then 13 else if digit == "e" || digit == "E" then 14
        else if digit == "f" || digit == "F" then 15
        else throw "Invalid hex digit: ${digit}";

      # Convert two hex digits to decimal
      hexPairToInt = hexPair:
        let
          high = hexDigitToInt (builtins.substring 0 1 hexPair);
          low = hexDigitToInt (builtins.substring 1 1 hexPair);
        in
        high * 16 + low;

      # Extract RGB components
      r = hexPairToInt (builtins.substring 0 2 normalizedHex);
      g = hexPairToInt (builtins.substring 2 2 normalizedHex);
      b = hexPairToInt (builtins.substring 4 2 normalizedHex);
    in
    { inherit r g b; };

  # Convert RGB components back to hex
  # rgbToHex 255 107 107 -> "#ff6b6b"
  rgbToHex = r: g: b:
    let
      # Helper function to convert number to hex digit
      intToHexDigit = n:
        if n == 0 then "0" else if n == 1 then "1" else if n == 2 then "2"
        else if n == 3 then "3" else if n == 4 then "4" else if n == 5 then "5"
        else if n == 6 then "6" else if n == 7 then "7" else if n == 8 then "8"
        else if n == 9 then "9" else if n == 10 then "a" else if n == 11 then "b"
        else if n == 12 then "c" else if n == 13 then "d" else if n == 14 then "e"
        else if n == 15 then "f"
        else throw "Invalid hex value: ${toString n}";

      # Convert number to two-digit hex string
      toHex = n:
        let
          high = intToHexDigit (n / 16);
          low = intToHexDigit (n - (n / 16) * 16);
        in
        "${high}${low}";
    in
    "#${toHex r}${toHex g}${toHex b}";

  # Convert hex to RGB string
  # hexToRgbString "#ff6b6b" -> "255,107,107"
  hexToRgbString = hex:
    let rgb = hexToRgb hex;
    in "${toString rgb.r},${toString rgb.g},${toString rgb.b}";

  # Remove hash prefix from hex colors (for config files that don't want #)
  # stripHex "#ff6b6b" -> "ff6b6b"
  stripHex = hex: lib.removePrefix "#" hex;

  # Ensure hex has hash prefix
  # ensureHex "ff6b6b" -> "#ff6b6b"
  # ensureHex "#ff6b6b" -> "#ff6b6b"
  ensureHex = hex:
    if lib.hasPrefix "#" hex then hex else "#${hex}";

  # ═══════════════════════════════════════════════════════════════════════════
  # UNIT UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Convert number to pixel string
  # toPx 16 -> "16px"
  toPx = value: "${toString value}px";

  # Convert pixels to rem (requires base rem size)
  # toRem 16 16 -> "1rem" (16px with 16px base)
  # toRem 32 16 -> "2rem" (32px with 16px base)
  toRem = value: baseSize: "${toString (value / baseSize)}rem";

  # Convert number to em string
  # toEm 1.5 -> "1.5em"
  toEm = value: "${toString value}em";

  # Convert number to percentage string
  # toPercent 50 -> "50%"
  toPercent = value: "${toString value}%";

  # ═══════════════════════════════════════════════════════════════════════════
  # TIME UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Convert number to milliseconds string
  # toMs 300 -> "300ms"
  toMs = value: "${toString value}ms";

  # Convert number to seconds string
  # toS 1.5 -> "1.5s"
  toS = value: "${toString value}s";

  # Convert milliseconds to seconds
  # msToS 1500 -> "1.5s"
  msToS = ms: "${toString (ms / 1000.0)}s";

  # ═══════════════════════════════════════════════════════════════════════════
  # FONT UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Convert font list to CSS string
  # fontListToCss ["Inter" "system-ui" "sans-serif"] -> "Inter, system-ui, sans-serif"
  fontListToCss = fonts: lib.concatStringsSep ", " fonts;

  # Get first font from list (for configs that only support single fonts)
  # fontListToSingle ["Inter" "system-ui" "sans-serif"] -> "Inter"
  fontListToSingle = fonts: lib.head fonts;

  # ═══════════════════════════════════════════════════════════════════════════
  # CSS UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Create CSS cubic-bezier function
  # cubicBezier 0.25 0.46 0.45 0.94 -> "cubic-bezier(0.25, 0.46, 0.45, 0.94)"
  cubicBezier = x1: y1: x2: y2:
    "cubic-bezier(${toString x1}, ${toString y1}, ${toString x2}, ${toString y2})";

  # Create CSS rgba function
  # rgba 255 107 107 0.8 -> "rgba(255, 107, 107, 0.8)"
  rgba = r: g: b: a:
    "rgba(${toString r}, ${toString g}, ${toString b}, ${toString a})";

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Check if string is valid hex color
  # isValidHex "#ff6b6b" -> true
  # isValidHex "ff6b6b" -> true  
  # isValidHex "#gggggg" -> false
  isValidHex = hex:
    let
      cleanHex = lib.removePrefix "#" hex;
      length = builtins.stringLength cleanHex;
      isValidLength = length == 3 || length == 6;
      # Simple regex-like check for hex characters
      isHexChars = builtins.match "[0-9a-fA-F]*" cleanHex != null;
    in
    isValidLength && isHexChars;

  # Check if value is a positive number
  # isPositiveNumber 16 -> true
  # isPositiveNumber (-5) -> false
  isPositiveNumber = value:
    builtins.isInt value && value >= 0;

  # ═══════════════════════════════════════════════════════════════════════════
  # DEBUG UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Pretty print any value for debugging
  debug = value: builtins.trace (builtins.toJSON value) value;

  # Create debug message with context
  debugWith = message: value:
    builtins.trace "${message}: ${builtins.toJSON value}" value;
}
