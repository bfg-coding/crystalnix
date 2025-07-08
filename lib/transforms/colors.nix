# Design System - Color Transform Functions
# lib/transforms/colors.nix
#
# Transforms raw color values into multiple format objects

{ lib, utils, defaults }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # MAIN COLOR TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform hex color into multiple formats
  # Input: "#ff6b6b" or "ff6b6b"
  # Output: { hex = "#ff6b6b"; conf = "ff6b6b"; rgb = { r = 255; g = 107; b = 107; }; }
  color = hexValue:
    let
      # Normalize input - ensure we have a clean hex value
      normalizedHex =
        if builtins.isString hexValue
        then utils.ensureHex hexValue
        else throw "Color value must be a hex string, got: ${builtins.typeOf hexValue}";

      # Validate the hex color
      isValid = utils.isValidHex normalizedHex;

      # If validation enabled and color is invalid, throw error
      validated =
        if defaults.features.enableValidation && !isValid
        then throw "${defaults.errors.invalidHex}: ${hexValue}"
        else normalizedHex;

      # Convert to RGB for additional formats
      rgb = utils.hexToRgb validated;

    in
    {
      # Standard hex format with hash (for CSS, most configs)
      hex = validated;

      # Config format without hash (for Hyprland, some terminal configs)
      conf = utils.stripHex validated;

      # RGB object format (for programmatic use)
      rgb = rgb;

      # RGB string format (for configs that want "255,107,107")
      rgbString = utils.hexToRgbString validated;

      # RGBA function (assumes full opacity)
      rgba = utils.rgba rgb.r rgb.g rgb.b 1.0;

      # Raw input (for debugging/fallback)
      raw = hexValue;

      # Debug info (only included if debug enabled)
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = hexValue;
        normalized = normalizedHex;
        isValid = isValid;
        rgb = rgb;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # SPECIALIZED COLOR TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform color specifically for Hyprland (no hash, lowercase)
  hyprlandColor = hexValue:
    let baseColor = color hexValue;
    in {
      inherit (baseColor) raw rgb;
      hyprland = lib.toLower baseColor.conf;
      hex = baseColor.hex;
    };

  # Transform color for Kitty terminal (needs hex format)
  kittyColor = hexValue:
    let baseColor = color hexValue;
    in {
      inherit (baseColor) raw rgb;
      kitty = baseColor.hex;
      hex = baseColor.hex;
    };

  # Transform color for i3/sway (supports hex)
  i3Color = hexValue:
    let baseColor = color hexValue;
    in {
      inherit (baseColor) raw rgb;
      i3 = baseColor.hex;
      hex = baseColor.hex;
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Validate a color value
  validateColor = hexValue:
    builtins.isString hexValue && utils.isValidHex hexValue;

  # Get color info for debugging
  colorInfo = hexValue:
    let
      transformed = color hexValue;
      rgb = transformed.rgb;
    in
    {
      inherit (transformed) hex conf;
      inherit rgb;
      brightness = (rgb.r * 0.299 + rgb.g * 0.587 + rgb.b * 0.114) / 255;
      isDark = transformed.rgb.r + transformed.rgb.g + transformed.rgb.b < 384; # 128 * 3
      isLight = !transformed.isDark;
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BATCH COLOR PROCESSING
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform a set of colors (useful for theme processing)
  # transformColors { primary = "#ff6b6b"; secondary = "#4ecdc4"; }
  # Returns: { primary = { hex = ...; conf = ...; }; secondary = { ... }; }
  transformColors = colorSet:
    lib.mapAttrs (name: value: color value) colorSet;

  # Transform nested color structure (for complex themes)
  # transformNestedColors { brand = { primary = "#ff6b6b"; secondary = "#4ecdc4"; }; }
  transformNestedColors = colorStructure:
    lib.mapAttrs
      (key: value:
        if builtins.isAttrs value
        then transformNestedColors value
        else color value
      )
      colorStructure;
}
