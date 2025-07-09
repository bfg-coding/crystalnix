# Design System - Built-in Themes (Updated)
# themes/default.nix
#
# Exports all built-in raw themes for the design system
# These themes contain only raw values and will be processed by the system

{ lib }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # MAIN THEMES
  # ═══════════════════════════════════════════════════════════════════════════

  # Dark theme - modern, easy on the eyes
  dark = import ./dark.nix { inherit lib; };

  # Light theme - clean, professional
  light = import ./light.nix { inherit lib; };

  # Tokyo Night theme - vibrant, inspired by Tokyo's neon nights
  tokyonight = import ./tokyonight.nix { inherit lib; };

  # ═══════════════════════════════════════════════════════════════════════════
  # THEME REGISTRY
  # ═══════════════════════════════════════════════════════════════════════════

  # All available themes
  all = {
    inherit dark light tokyonight;
  };

  # List of theme names
  available = builtins.attrNames all;

  # Default theme (falls back to dark)
  default = dark;

  # ═══════════════════════════════════════════════════════════════════════════
  # THEME UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Get theme by name with fallback to default
  getTheme = name: all.${name} or default;

  # Check if theme exists
  hasTheme = name: builtins.hasAttr name all;

  # Theme metadata
  metadata = {
    dark = {
      name = "Dark";
      description = "Modern dark theme optimized for low-light environments";
      category = "dark";
      tags = [ "modern" "sleek" "terminal-friendly" ];
    };

    light = {
      name = "Light";
      description = "Clean light theme perfect for documentation and professional use";
      category = "light";
      tags = [ "clean" "professional" "accessible" ];
    };

    tokyonight = {
      name = "Tokyo Night";
      description = "Vibrant dark theme inspired by Tokyo's neon-lit night skyline";
      category = "dark";
      tags = [ "vibrant" "colorful" "neon" "popular" "programmer-friendly" ];
    };
  };

  # Get metadata for a theme
  getMetadata = name: metadata.${name} or {
    name = name;
    description = "Custom theme";
    category = "unknown";
    tags = [ ];
  };
}
