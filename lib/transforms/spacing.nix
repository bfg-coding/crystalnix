# Design System - Spacing Transform Functions
# lib/transforms/spacing.nix
#
# Transforms raw spacing/sizing values into multiple unit formats

{ lib, utils, defaults }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # MAIN SPACING TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform spacing value into multiple units
  # Input: 16 (pixels)
  # Output: { px = "16px"; rem = "1rem"; raw = 16; }
  spacing = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Check constraints if validation enabled
      withinRange =
        if defaults.features.enableValidation
        then value >= defaults.constraints.spacing.min &&
          value <= defaults.constraints.spacing.max
        else true;

      # If validation enabled and value is invalid, throw error  
      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value}"
          else value
        else value;

    in
    {
      # Pixel string format (most common for CSS)
      px = utils.toPx validated;

      # Rem format (relative to base font size)  
      rem = utils.toRem validated defaults.remBase;

      # Em format (same as rem in this context)
      em = utils.toRem validated defaults.remBase;

      # Raw number (for calculations, programmatic use)
      raw = validated;

      # Debug info (only included if debug enabled)
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        remBase = defaults.remBase;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BORDER WIDTH TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform border width (similar to spacing but different constraints)
  # Input: 2 (pixels)
  # Output: { px = "2px"; raw = 2; }
  borderWidth = value:
    let
      isValid = builtins.isInt value || builtins.isFloat value;

      # Border widths are typically smaller than general spacing
      withinRange =
        if defaults.features.enableValidation
        then value >= 0 && value <= 20  # 0-20px seems reasonable for borders
        else true;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (border width should be 0-20px)"
          else value
        else value;

    in
    {
      # Pixel format (standard for borders)
      px = utils.toPx validated;

      # Raw number
      raw = validated;

      # Some applications might want string representation without unit
      value = toString validated;

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BORDER RADIUS TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform border radius (supports px, rem, and special values)
  # Input: 8 (pixels) or 9999 (for full rounding)
  # Output: { px = "8px"; rem = "0.5rem"; raw = 8; }
  borderRadius = value:
    let
      isValid = builtins.isInt value || builtins.isFloat value;

      # Special handling for "full" radius (very large number)
      isFull = value >= 9999;

      # Reasonable range for border radius
      withinRange =
        if defaults.features.enableValidation
        then value >= 0 && (value <= 100 || isFull)
        else true;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (border radius should be 0-100px or 9999+ for full)"
          else value
        else value;

    in
    {
      # Pixel format
      px = utils.toPx validated;

      # Rem format  
      rem = utils.toRem validated defaults.remBase;

      # Raw number
      raw = validated;

      # Special full radius handling
      full = if isFull then "9999px" else utils.toPx validated;

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isFull = isFull;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # SPECIALIZED SPACING TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform for applications that prefer different default units
  spacingInRem = value:
    let baseSpacing = spacing value;
    in baseSpacing // {
      # Override default to be rem instead of px
      default = baseSpacing.rem;
    };

  spacingInPx = value:
    let baseSpacing = spacing value;
    in baseSpacing // {
      # Override default to be px
      default = baseSpacing.px;
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BATCH SPACING PROCESSING
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform a set of spacing values
  # transformSpacing { sm = 8; md = 16; lg = 32; }
  # Returns: { sm = { px = "8px"; ... }; md = { px = "16px"; ... }; ... }
  transformSpacing = spacingSet:
    lib.mapAttrs (name: value: spacing value) spacingSet;

  # Transform nested spacing structure
  transformNestedSpacing = spacingStructure:
    lib.mapAttrs
      (key: value:
        if builtins.isAttrs value
        then transformNestedSpacing value
        else spacing value
      )
      spacingStructure;

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Validate a spacing value
  validateSpacing = value:
    (builtins.isInt value || builtins.isFloat value) && value >= 0;

  # Get spacing info for debugging
  spacingInfo = value:
    let transformed = spacing value;
    in {
      inherit (transformed) px rem raw;
      inInches = value / 96.0; # Assuming 96 DPI
      inPoints = value * 0.75; # 1px = 0.75pt
      category =
        if value == 0 then "none"
        else if value <= 4 then "xs"
        else if value <= 8 then "sm"
        else if value <= 16 then "md"
        else if value <= 32 then "lg"
        else if value <= 64 then "xl"
        else "xxl";
    };
}
