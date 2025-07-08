# Design System - Transform Functions
# lib/transforms/default.nix
#
# Exports all transform functions that convert raw values into format objects
# Each transform takes a raw value and returns { format1 = value1; format2 = value2; ... }

{ lib, utils, defaults }:

let
  # Import all transform modules
  colorTransforms = import ./colors.nix { inherit lib utils defaults; };
  spacingTransforms = import ./spacing.nix { inherit lib utils defaults; };
  typographyTransforms = import ./typography.nix { inherit lib utils defaults; };
  motionTransforms = import ./motion.nix { inherit lib utils defaults; };
  effectsTransforms = import ./effects.nix { inherit lib utils defaults; };

in
rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform hex color into multiple formats
  # color "#ff6b6b" -> { hex = "#ff6b6b"; conf = "ff6b6b"; rgb = {...}; }
  color = colorTransforms.color;

  # ═══════════════════════════════════════════════════════════════════════════
  # LAYOUT TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform spacing value into multiple units
  # spacing 16 -> { px = "16px"; rem = "1rem"; raw = 16; }
  spacing = spacingTransforms.spacing;

  # Border width transforms (similar to spacing)
  borderWidth = spacingTransforms.borderWidth;

  # Border radius transforms (supports px, rem, raw)
  borderRadius = spacingTransforms.borderRadius;

  # ═══════════════════════════════════════════════════════════════════════════
  # TYPOGRAPHY TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Font size transforms (px, rem, raw)
  fontSize = typographyTransforms.fontSize;

  # Font family transforms (css string, single font, raw array)
  fontFamily = typographyTransforms.fontFamily;

  # Font weight (just pass through as number)
  fontWeight = typographyTransforms.fontWeight;

  # Line height (pass through as number/ratio)
  lineHeight = typographyTransforms.lineHeight;

  # Letter spacing (em, raw)
  letterSpacing = typographyTransforms.letterSpacing;

  # ═══════════════════════════════════════════════════════════════════════════
  # MOTION TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Duration transforms (ms, s, raw)
  duration = motionTransforms.duration;

  # Easing functions (pass through as string)
  easing = motionTransforms.easing;

  # ═══════════════════════════════════════════════════════════════════════════
  # EFFECT TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Opacity (pass through as number, validate 0-1)
  opacity = effectsTransforms.opacity;

  # Z-index (pass through as number or string)
  zIndex = effectsTransforms.zIndex;

  # ═══════════════════════════════════════════════════════════════════════════
  # SPECIAL TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Raw transform - just passes value through unchanged
  # raw "any-value" -> "any-value"
  raw = value: value;

  # ═══════════════════════════════════════════════════════════════════════════
  # TRANSFORM REGISTRY
  # ═══════════════════════════════════════════════════════════════════════════

  # Map of all available transforms (used by processor)
  registry = {
    inherit color;
    inherit spacing borderWidth borderRadius;
    inherit fontSize fontFamily fontWeight lineHeight letterSpacing;
    inherit duration easing;
    inherit opacity zIndex;
    inherit raw;
  };

  # Get transform function by name, with fallback to raw
  getTransform = name:
    registry.${name} or raw;

  # List all available transform names
  available = builtins.attrNames registry;

  # Debug info
  debug = {
    inherit registry;
    transformCount = builtins.length available;
    inherit available;
  };
}
