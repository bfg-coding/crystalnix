# Design System - Transform Schema
# lib/schema.nix
#
# Defines which transform type to apply to each theme path
# This tells the processor how to transform raw values into format objects

{
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # All color values get color transforms (hex, conf, rgb)
  colors = "color";

  # ═══════════════════════════════════════════════════════════════════════════
  # LAYOUT TRANSFORMS  
  # ═══════════════════════════════════════════════════════════════════════════

  # Spacing values get spacing transforms (px, rem, raw)
  spacing = "spacing";

  # Border properties
  borders = {
    width = "borderWidth"; # px, raw
    radius = "borderRadius"; # px, rem, raw
    style = "raw"; # strings stay as-is
  };

  # Size values  
  size = "spacing"; # Same as spacing

  # Breakpoints stay as raw numbers
  breakpoints = "raw";

  # ═══════════════════════════════════════════════════════════════════════════
  # TYPOGRAPHY TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  typography = {
    # Font families get font transforms (css, single, raw)
    fontFamily = "fontFamily";

    # Font sizes get fontSize transforms (px, rem, raw)
    fontSize = "fontSize";

    # Font weights are just numbers
    fontWeight = "fontWeight";

    # Line heights are ratios/numbers
    lineHeight = "lineHeight";

    # Letter spacing gets spacing-like transforms
    letterSpacing = "letterSpacing";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VISUAL EFFECTS TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  effects = {
    # Shadows are CSS strings, keep as raw
    shadow = "raw";

    # Opacity values are 0-1 numbers
    opacity = "opacity";

    # Blur values could be processed, but keeping simple for now
    blur = "raw";
    backdropBlur = "raw";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # MOTION TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  motion = {
    # Duration values get time transforms (ms, s, raw)
    duration = "duration";

    # Easing functions are CSS strings
    easing = "easing";

    # Delays are also durations
    delay = "duration";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # INTERACTION TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  interaction = {
    # Cursor values are CSS strings
    cursor = "raw";

    # Input settings are configuration objects
    input = "raw";

    # Focus ring properties
    focus = {
      # Most focus properties stay raw (strings/numbers)
      outlineWidth = "borderWidth";
      outlineOffset = "spacing";
      outlineStyle = "raw";

      ring = {
        width = "borderWidth";
        offset = "spacing";
      };
    };

    # State timing
    states = "raw";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # Z-INDEX TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Z-index values are just numbers or strings
  zIndex = "zIndex";

  # ═══════════════════════════════════════════════════════════════════════════
  # SPECIAL HANDLING
  # ═══════════════════════════════════════════════════════════════════════════

  # Any path not specified above defaults to "raw" (no transformation)
  _default = "raw";

  # Paths to completely ignore during processing (useful for metadata)
  _ignore = [
    "_meta"
    "_version"
    "_description"
  ];
}
