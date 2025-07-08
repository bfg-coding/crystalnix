# Design System - Typography Transform Functions
# lib/transforms/typography.nix
#
# Transforms raw typography values into multiple format objects

{ lib, utils, defaults }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # FONT SIZE TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform font size into multiple units
  # Input: 16 (pixels)
  # Output: { px = "16px"; rem = "1rem"; raw = 16; }
  fontSize = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Check font size constraints
      withinRange =
        if defaults.features.enableValidation
        then value >= defaults.constraints.fontSize.min &&
          value <= defaults.constraints.fontSize.max
        else true;

      # If validation enabled and value is invalid, throw error  
      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (font size should be ${toString defaults.constraints.fontSize.min}-${toString defaults.constraints.fontSize.max}px)"
          else value
        else value;

    in
    {
      # Pixel string format (common for CSS)
      px = utils.toPx validated;

      # Rem format (relative to base font size)  
      rem = utils.toRem validated defaults.remBase;

      # Em format (same as rem in this context)
      em = utils.toRem validated defaults.remBase;

      # Raw number (for calculations)
      raw = validated;

      # Point size (for print/some applications)
      pt = "${toString (validated * 0.75)}pt";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        remBase = defaults.remBase;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # FONT FAMILY TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform font family list into multiple formats
  # Input: ["Inter" "system-ui" "sans-serif"]
  # Output: { css = "Inter, system-ui, sans-serif"; single = "Inter"; raw = [...]; }
  fontFamily = value:
    let
      # Validate input is a list of strings
      isValid = builtins.isList value &&
        builtins.all builtins.isString value &&
        builtins.length value > 0;

      validated =
        if defaults.features.enableValidation && !isValid
        then throw "Font family must be a non-empty list of strings, got: ${builtins.typeOf value}"
        else value;

    in
    {
      # CSS format (comma-separated, quoted if needed)
      css = utils.fontListToCss validated;

      # Single font (first in list, for configs that only support one)
      single = utils.fontListToSingle validated;

      # Raw array (for programmatic use)
      raw = validated;

      # Alternative formats for different applications
      kitty = utils.fontListToSingle validated; # Kitty uses single font
      i3 = utils.fontListToSingle validated; # i3 uses single font

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        fontCount = builtins.length validated;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # FONT WEIGHT TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform font weight (simple pass-through with validation)
  # Input: 400 or "normal"
  # Output: { raw = 400; css = "400"; }
  fontWeight = value:
    let
      # Handle both numeric and string weights
      normalizedValue =
        if builtins.isString value then
          if value == "normal" then 400
          else if value == "bold" then 700
          else if value == "light" then 300
          else if value == "thin" then 100
          else if value == "black" then 900
          else throw "Unknown font weight string: ${value}"
        else value;

      # Validate range (100-900 in increments of 100, plus some common values)
      validWeights = [ 100 200 300 400 500 600 700 800 900 ];
      isValid = builtins.elem normalizedValue validWeights;

      validated =
        if defaults.features.enableValidation && !isValid
        then throw "Font weight must be one of: ${lib.concatMapStringsSep ", " toString validWeights}"
        else normalizedValue;

    in
    {
      # Raw number (most common)
      raw = validated;

      # CSS string format
      css = toString validated;

      # Named format (for readability)
      name =
        if validated == 100 then "thin"
        else if validated == 200 then "extralight"
        else if validated == 300 then "light"
        else if validated == 400 then "normal"
        else if validated == 500 then "medium"
        else if validated == 600 then "semibold"
        else if validated == 700 then "bold"
        else if validated == 800 then "extrabold"
        else if validated == 900 then "black"
        else toString validated;

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        normalized = normalizedValue;
        validated = validated;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # LINE HEIGHT TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform line height (ratio or pixel value)
  # Input: 1.5 (ratio) or 24 (pixels)
  # Output: { raw = 1.5; css = "1.5"; }
  lineHeight = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Line height can be ratio (0.5-3.0) or pixel value (8-200)
      isRatio = value <= 3.0;
      withinRange =
        if defaults.features.enableValidation then
          if isRatio
          then value >= 0.5 && value <= 3.0
          else value >= 8 && value <= 200
        else true;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (line height should be 0.5-3.0 for ratios or 8-200px for absolute)"
          else value
        else value;

    in
    {
      # Raw number (most common - CSS accepts unitless for ratios)
      raw = validated;

      # CSS format (same as raw for ratios, with px for absolute values)
      css = if isRatio then toString validated else utils.toPx validated;

      # Always provide pixel equivalent (useful for calculations)
      px = if isRatio then null else utils.toPx validated;

      # Ratio equivalent (useful for responsive design)
      ratio = if isRatio then validated else null;

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isRatio = isRatio;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # LETTER SPACING TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform letter spacing into em/pixel formats
  # Input: 0.025 (em units) or 1 (pixels)
  # Output: { em = "0.025em"; raw = 0.025; }
  letterSpacing = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Letter spacing is typically small values in em or small pixel values
      isEmValue = value >= -0.5 && value <= 0.5; # Reasonable em range
      withinRange =
        if defaults.features.enableValidation then
          isEmValue || (value >= -10 && value <= 10)  # Or reasonable pixel range
        else true;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (letter spacing should be -0.5 to 0.5em or -10 to 10px)"
          else value
        else value;

    in
    {
      # Em format (most common for letter spacing)
      em = "${toString validated}em";

      # Raw number
      raw = validated;

      # Pixel format (if input seems to be pixels)
      px = if isEmValue then null else utils.toPx validated;

      # Percentage (sometimes used)
      percent = if isEmValue then "${toString (validated * 100)}%" else null;

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isEmValue = isEmValue;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BATCH TYPOGRAPHY PROCESSING
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform typography object (useful for theme processing)
  transformTypography = typographySet:
    lib.mapAttrs
      (name: value:
        if name == "fontSize" then fontSize value
        else if name == "fontFamily" then fontFamily value
        else if name == "fontWeight" then fontWeight value
        else if name == "lineHeight" then lineHeight value
        else if name == "letterSpacing" then letterSpacing value
        else value  # Pass through unknown properties
      )
      typographySet;

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Validate typography values
  validateFontSize = value: (builtins.isInt value || builtins.isFloat value) && value > 0;
  validateFontFamily = value: builtins.isList value && builtins.all builtins.isString value;
  validateFontWeight = value:
    (builtins.isInt value && value >= 100 && value <= 900) ||
    (builtins.isString value && builtins.elem value [ "thin" "light" "normal" "bold" "black" ]);
}
