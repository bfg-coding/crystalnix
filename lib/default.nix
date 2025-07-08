# Design System - Main Entry Point
# lib/default.nix
# 
# Usage: 
#   designSystem = import ./lib { inherit lib; };
#   stylesheet = designSystem.processTheme rawTheme;

{ lib }:

let
  # Import all the core modules
  utils = import ./utils.nix { inherit lib; };
  defaults = import ./defaults.nix;
  transforms = import ./transforms { inherit lib utils defaults; };
  schema = import ./schema.nix;
  themes = import ../themes { inherit lib; };

  # Import the main processor
  processTheme = import ./processor.nix {
    inherit lib utils schema transforms defaults;
  };

in
rec {
  # Main function - transforms raw theme into full stylesheet
  inherit processTheme;

  # Built-in themes ready to use (these are raw themes)
  inherit themes;

  # Export internals for advanced usage/debugging
  inherit utils defaults transforms schema;

  # Convenience functions for common usage
  darkStylesheet = processTheme themes.dark;
  lightStylesheet = processTheme themes.light;

  # Helper for extending themes
  extendTheme = baseTheme: overrides:
    lib.recursiveUpdate baseTheme overrides;

  # Version info
  version = "2.0.0";

  # For debugging - shows what transforms are available
  availableTransforms = builtins.attrNames transforms;
}
