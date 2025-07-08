# Design System - Effects Transform Functions
# lib/transforms/effects.nix
#
# Transforms raw effect values (opacity, z-index, etc.) into format objects

{ lib, utils, defaults }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # OPACITY TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform opacity value with validation
  # Input: 0.8 (0-1 range)
  # Output: { raw = 0.8; css = "0.8"; percent = "80%"; }
  opacity = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Check opacity constraints (0-1 range)
      withinRange =
        if defaults.features.enableValidation
        then value >= defaults.constraints.opacity.min &&
          value <= defaults.constraints.opacity.max
        else true;

      # If validation enabled and value is invalid, throw error  
      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (opacity should be 0.0-1.0)"
          else value
        else value;

    in
    {
      # Raw number (most common for CSS)
      raw = validated;

      # CSS format (same as raw)
      css = toString validated;

      # Percentage format (for some applications)
      percent = "${toString (validated * 100)}%";

      # Semantic categories
      category =
        if validated == 0.0 then "invisible"
        else if validated < 0.3 then "very-transparent"
        else if validated < 0.7 then "transparent"
        else if validated < 1.0 then "semi-opaque"
        else "opaque";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        withinRange = withinRange;
        asPercent = validated * 100;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # Z-INDEX TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform z-index value (number or string like "auto")
  # Input: 10 or "auto"
  # Output: { raw = 10; css = "10"; }
  zIndex = value:
    let
      # Validate input is a number or specific string
      isValidNumber = builtins.isInt value;
      isValidString = builtins.isString value && builtins.elem value [ "auto" "initial" "inherit" ];
      isValid = isValidNumber || isValidString;

      # Reasonable z-index range (avoid extremely large numbers)
      withinRange =
        if defaults.features.enableValidation && isValidNumber
        then value >= -1000 && value <= 10000
        else true;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "Z-index must be a number or 'auto', got: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (z-index should be -1000 to 10000)"
          else value
        else value;

    in
    {
      # Raw value (number or string)
      raw = validated;

      # CSS format (convert number to string)
      css = toString validated;

      # Semantic layer (for common z-index values)
      layer =
        if builtins.isString validated then validated
        else if validated < 0 then "behind"
        else if validated == 0 then "base"
        else if validated < 100 then "content"
        else if validated < 1000 then "overlay"
        else if validated < 2000 then "modal"
        else if validated < 5000 then "popover"
        else "critical";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isNumber = isValidNumber;
        isString = isValidString;
        withinRange = withinRange;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # SHADOW TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform shadow value (mostly pass-through)
  # Input: "0 2px 4px rgba(0,0,0,0.1)"
  # Output: { raw = "0 2px 4px rgba(0,0,0,0.1)"; css = "0 2px 4px rgba(0,0,0,0.1)"; }
  shadow = value:
    let
      # Validate input is a string
      isValid = builtins.isString value;

      # Check for common shadow keywords
      isKeyword = builtins.elem value [ "none" "initial" "inherit" ];

      # Basic validation for box-shadow format (very basic)
      looksLikeShadow = isKeyword || (lib.hasInfix "px" value) || (lib.hasInfix "rem" value);

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "Shadow must be a string, got: ${builtins.typeOf value}"
          else if defaults.features.strictMode && !looksLikeShadow then throw "Shadow value doesn't look like valid CSS shadow: ${value}"
          else value
        else value;

    in
    {
      # Raw string (most common)
      raw = validated;

      # CSS format (same as raw)
      css = validated;

      # Basic categorization
      category =
        if validated == "none" then "none"
        else if lib.hasInfix "inset" validated then "inset"
        else if lib.hasInfix "0px" validated then "subtle"
        else "elevated";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isKeyword = isKeyword;
        looksLikeShadow = looksLikeShadow;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BLUR TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform blur value
  # Input: "4px" or "blur(4px)"
  # Output: { raw = "blur(4px)"; css = "blur(4px)"; }
  blur = value:
    let
      # Validate input is a string
      isValid = builtins.isString value;

      # Normalize - ensure blur() wrapper
      normalized =
        if lib.hasPrefix "blur(" value then value
        else if value == "none" then "none"
        else "blur(${value})";

      validated =
        if defaults.features.enableValidation && !isValid
        then throw "Blur must be a string, got: ${builtins.typeOf value}"
        else normalized;

    in
    {
      # Raw value (with blur() wrapper)
      raw = validated;

      # CSS format (same as raw)
      css = validated;

      # Original input (for reference)
      input = value;

      # Category
      category =
        if validated == "none" then "none"
        else if lib.hasInfix "2px" validated || lib.hasInfix "4px" validated then "subtle"
        else if lib.hasInfix "8px" validated || lib.hasInfix "12px" validated then "medium"
        else "heavy";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        normalized = normalized;
        validated = validated;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BATCH EFFECTS PROCESSING
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform effects object
  transformEffects = effectsSet:
    lib.mapAttrs
      (name: value:
        if name == "opacity" then opacity value
        else if name == "zIndex" then zIndex value
        else if name == "shadow" then shadow value
        else if name == "blur" || name == "backdropBlur" then blur value
        else value  # Pass through unknown properties
      )
      effectsSet;

  # ═══════════════════════════════════════════════════════════════════════════
  # PREDEFINED COMMON VALUES
  # ═══════════════════════════════════════════════════════════════════════════

  # Common opacity values
  commonOpacities = {
    invisible = opacity 0.0;
    faint = opacity 0.1;
    light = opacity 0.25;
    medium = opacity 0.5;
    strong = opacity 0.75;
    mostlyOpaque = opacity 0.9;
    opaque = opacity 1.0;
  };

  # Common z-index layers
  commonZIndices = {
    behind = zIndex (-1);
    base = zIndex 0;
    content = zIndex 10;
    overlay = zIndex 100;
    modal = zIndex 1000;
    popover = zIndex 2000;
    tooltip = zIndex 3000;
    notification = zIndex 4000;
    maximum = zIndex 9999;
  };

  # Common shadows
  commonShadows = {
    none = shadow "none";
    subtle = shadow "0 1px 2px rgba(0, 0, 0, 0.05)";
    small = shadow "0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)";
    medium = shadow "0 4px 6px rgba(0, 0, 0, 0.1), 0 2px 4px rgba(0, 0, 0, 0.06)";
    large = shadow "0 10px 15px rgba(0, 0, 0, 0.1), 0 4px 6px rgba(0, 0, 0, 0.05)";
    xlarge = shadow "0 20px 25px rgba(0, 0, 0, 0.1), 0 10px 10px rgba(0, 0, 0, 0.04)";
    inner = shadow "inset 0 2px 4px rgba(0, 0, 0, 0.06)";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Validate effect values
  validateOpacity = value: (builtins.isInt value || builtins.isFloat value) && value >= 0.0 && value <= 1.0;
  validateZIndex = value: builtins.isInt value || builtins.elem value [ "auto" "initial" "inherit" ];
  validateShadow = value: builtins.isString value;
  validateBlur = value: builtins.isString value;
}
