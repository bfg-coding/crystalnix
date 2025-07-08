# Design System - Default Configuration
# lib/defaults.nix
#
# Base configuration values used throughout the design system

{
  # ═══════════════════════════════════════════════════════════════════════════
  # UNIT DEFAULTS
  # ═══════════════════════════════════════════════════════════════════════════

  # Base font size in pixels (used for rem calculations)
  # Most browsers default to 16px, so 1rem = 16px
  remBase = 16;

  # Default unit preferences for different value types
  defaultUnits = {
    spacing = "px"; # Default spacing unit
    fontSize = "px"; # Default font size unit  
    borderWidth = "px"; # Default border width unit
    borderRadius = "px"; # Default border radius unit
    duration = "ms"; # Default animation duration unit
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TRANSFORM DEFAULTS
  # ═══════════════════════════════════════════════════════════════════════════

  # Which formats to generate for each value type
  formats = {
    color = [ "hex" "conf" "rgb" ];
    spacing = [ "px" "rem" "raw" ];
    fontSize = [ "px" "rem" "raw" ];
    fontWeight = [ "raw" ];
    fontFamily = [ "css" "single" "raw" ];
    duration = [ "ms" "s" "raw" ];
    easing = [ "raw" ];
    borderWidth = [ "px" "raw" ];
    borderRadius = [ "px" "rem" "raw" ];
    opacity = [ "raw" ];
    zIndex = [ "raw" ];
    lineHeight = [ "raw" ];
    letterSpacing = [ "em" "raw" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION DEFAULTS
  # ═══════════════════════════════════════════════════════════════════════════

  # Value constraints for validation
  constraints = {
    color = {
      # Colors should be valid hex strings
      validate = "hex";
    };

    spacing = {
      # Spacing should be non-negative numbers
      min = 0;
      max = 1000; # Reasonable max for px values
    };

    fontSize = {
      min = 8; # Minimum readable font size
      max = 200; # Reasonable max font size
    };

    duration = {
      min = 0; # No negative durations
      max = 10000; # 10 second max seems reasonable
    };

    opacity = {
      min = 0;
      max = 1;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ERROR MESSAGES
  # ═══════════════════════════════════════════════════════════════════════════

  errors = {
    invalidHex = "Invalid hex color format. Expected #rrggbb or #rgb";
    invalidNumber = "Expected a number value";
    outOfRange = "Value out of valid range";
    missingTransform = "No transform found for value type";
    invalidThemeStructure = "Invalid theme structure";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FEATURE FLAGS
  # ═══════════════════════════════════════════════════════════════════════════

  features = {
    # Enable validation during theme processing
    enableValidation = true;

    # Include debug metadata in output
    includeDebugInfo = false;

    # Strict mode throws errors on invalid values
    strictMode = true;

    # Generate all possible formats even if not requested
    generateAllFormats = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # PERFORMANCE SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════

  performance = {
    # Cache transform results (useful for large themes)
    enableCaching = false;

    # Maximum nesting depth for theme objects
    maxNestingDepth = 10;

    # Warn about potentially expensive operations
    warnOnLargeThemes = true;
    largeThemeThreshold = 1000; # Number of leaf values
  };
}
