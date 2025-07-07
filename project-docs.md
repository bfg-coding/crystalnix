# crystalnix

* Generated on July 7, 2025 at 5:54 PM*

This document contains a comprehensive overview of the project files and structure.

## Table of Contents

- [Project Overview](#project-overview)
- [Project Statistics](#project-statistics)
- [File Structure](#file-structure)
- [File Contents](#file-contents)
  - [README.md](#readme-md)
  - [docs/integration.md](#docs-integration-md)
  - [docs/themes.md](#docs-themes-md)
  - [docs/tokens.md](#docs-tokens-md)
  - [flake.nix](#flake-nix)
  - [stylesheets/base.nix](#stylesheets-base-nix)
  - [themes/cyberpunk.nix](#themes-cyberpunk-nix)
  - [themes/dark.nix](#themes-dark-nix)
  - [themes/light.nix](#themes-light-nix)
  - [themes/minimal.nix](#themes-minimal-nix)

## Project Overview

- **Project Root:** `/home/justin/Repo/bfg/crystalnix`
- **Scan Date:** July 7, 2025
- **Scan Duration:** 327.677µs

### File Summary

- **Total Files Found:** 10
- **Files Processed:** 10
- **Files Skipped:** 0

### Size Information

- **Total Size:** 33.6 KB
- **Largest File:** `flake.nix` (12.1 KB)
- **Total Lines:** 1,210

## Project Statistics

### Files by Language

| Language | Files | Percentage |
|----------|-------|------------|
| Nix | 5 | 50.0% |
| Markdown | 1 | 10.0% |

### Files by Extension

| Extension | Files |
|-----------|-------|
| `.nix` | 6 |
| `.md` | 4 |

## File Structure

```
crystalnix/
├── README.md
├── flake.nix
├── docs/
  ├── integration.md
  ├── themes.md
  └── tokens.md
├── stylesheets/
  └── base.nix
├── themes/
  ├── cyberpunk.nix
  ├── dark.nix
  ├── light.nix
  └── minimal.nix
```

## File Contents

#### README.md {#readme-md}

- **Size:** 7.6 KB
- **Language:** Markdown
- **Lines:** 304
- **Modified:** July 7, 2025

```markdown

# 🔮 CrystalNix

A universal design system for Nix configurations. Create consistent, themeable interfaces across all your Nix-managed applications—from window managers to terminal emulators to status bars.

## Features

- **🎨 Universal Design Tokens** - One source of truth for colors, spacing, typography, and more
- **🌈 Built-in Themes** - Dark, light, minimal, and cyberpunk themes included
- **🔧 Easy Customization** - Override any token or create custom themes
- **⚡ Zero Runtime** - All values resolved at Nix evaluation time
- **🎯 Type Safe** - Nix catches configuration errors before deployment
- **📦 Flake Ready** - Simple integration with modern Nix workflows

## Quick Start

### 1. Add to your flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crystalnix.url = "github:yourusername/crystalnix";
  };

  outputs = { self, nixpkgs, crystalnix, ... }: {

    # Your configuration

  };
}
```

### 2. Use in your configuration

```nix

# home.nix

{ config, pkgs, lib, ... }:
let

  # Load a theme

  stylesheet = crystalnix.lib.mkStylesheet { theme = "dark"; };
in
{
  imports = [
    (import ./hyprland.nix { inherit config pkgs lib stylesheet; })
    (import ./waybar.nix { inherit config pkgs lib stylesheet; })
  ];
}
```

### 3. Reference tokens in your configs

```nix

# hyprland.nix

{ config, pkgs, lib, stylesheet, ... }:
{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps\_in = stylesheet.layout.spacing.sm;              # 8
      gaps\_out = stylesheet.layout.spacing.md;             # 16
      border\_size = stylesheet.layout.borders.width.normal; # 2
      "col.active\_border" = stylesheet.visual.colors.primary."500";
      "col.inactive\_border" = stylesheet.visual.colors.border.primary;
    };

    decoration = {
      rounding = stylesheet.layout.borders.radius.md;      # 8
      blur.size = stylesheet.visual.effects.blur.base;     # "blur(8px)"
      shadow.color = stylesheet.visual.colors.shadow.primary;
    };

    animations = {
      animation = [
        "windows, 1, ${toString stylesheet.motion.duration.normal}, ${stylesheet.motion.easing.smooth}"
        "fade, 1, ${toString stylesheet.motion.duration.fast}, linear"
      ];
    };
  };
}
```

## Available Themes

| Theme | Description |
|-------|-------------|
| `dark` | Modern dark theme with blue accents |
| `light` | Clean light theme with subtle shadows |
| `minimal` | Monochromatic with reduced spacing and effects |
| `cyberpunk` | Neon colors with glowing effects |

## Design System Structure

```nix
stylesheet = {

  # Layout properties

  layout = {
    spacing = { xs = 4; sm = 8; md = 16; lg = 32; xl = 64; /* ... */ };
    borders = {
      width = { thin = 1; normal = 2; thick = 4; };
      radius = { sm = 4; md = 8; lg = 16; full = 9999; };
    };
    size = { /* sizing scale */ };
    breakpoints = { /* responsive breakpoints */ };
  };

  # Visual properties

  visual = {
    colors = {

      # Base color scales

      red = { "50" = "#fef2f2"; "500" = "#ef4444"; /* ... */ };
      blue = { "50" = "#eff6ff"; "500" = "#3b82f6"; /* ... */ };

      # Semantic colors (set by themes)

      primary = { /* theme-specific */ };
      background = { primary = ""; secondary = ""; /* ... */ };
      text = { primary = ""; secondary = ""; /* ... */ };
      border = { primary = ""; focus = ""; /* ... */ };
    };
    typography = { /* font families, sizes, weights */ };
    effects = { shadow = {}; blur = {}; opacity = {}; };
  };

  # Motion properties

  motion = {
    duration = { fast = 150; normal = 250; slow = 400; };
    easing = { smooth = "cubic-bezier(...)"; linear = "linear"; };
    delay = { /* timing delays */ };
  };

  # Interaction properties

  interaction = {
    cursor = { timeout = 3; };
    input = { mouse = {}; keyboard = {}; };
    focus = { outlineWidth = 2; };
  };

  # Z-index scale

  zIndex = { overlay = 1000; modal = 2000; tooltip = 4000; };

  # Helper functions

  helpers = {
    rgba = r: g: b: a: "rgba(${r}, ${g}, ${b}, ${a})";
    px = value: "${toString value}px";
    /* ... */
  };
}
```

## Customization

### Override specific tokens

```nix
let
  stylesheet = crystalnix.lib.mkStylesheet {
    theme = "dark";
    overrides = {
      visual.colors.accent = "#ff6b6b";
      layout.spacing.md = 20;
      motion.duration.normal = 300;
    };
  };
```

### Create a custom theme

```nix

# themes/gruvbox.nix

{ baseStylesheet, lib }:
baseStylesheet // {
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = { "500" = "#458588"; };
      accent = "#d65d0e";

      background = {
        primary = "#282828";
        secondary = "#3c3836";
      };

      text = {
        primary = "#ebdbb2";
        secondary = "#d79921";
      };
    };
  };
}
```

### Use helpers for complex values

```nix
{
  wayland.windowManager.hyprland.settings = {
    decoration.shadow = {
      color = stylesheet.helpers.rgba 0 0 0 0.8;
      range = stylesheet.helpers.px stylesheet.layout.spacing.md;
    };
  };
}
```

## Real-world Examples

### Waybar Configuration

```nix

# waybar.nix

{ stylesheet, ... }:
{
  programs.waybar = {
    enable = true;
    style = ''
      \* {
        font-family: ${lib.concatStringsSep ", " stylesheet.visual.typography.fontFamily.sans};
        font-size: ${stylesheet.helpers.px stylesheet.visual.typography.fontSize.sm.size};
      }

      window#waybar {
        background-color: ${stylesheet.visual.colors.background.secondary};
        color: ${stylesheet.visual.colors.text.primary};
        border-radius: ${stylesheet.helpers.px stylesheet.layout.borders.radius.md};
      }

      .modules-left > widget:first-child > #workspaces {
        margin-left: ${stylesheet.helpers.px stylesheet.layout.spacing.md};
      }

# workspaces button.active {
        background-color: ${stylesheet.visual.colors.primary."500"};
        color: ${stylesheet.visual.colors.text.inverse};
      }
    '';
  };
}
```

### Kitty Terminal

```nix

# kitty.nix

{ stylesheet, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = builtins.head stylesheet.visual.typography.fontFamily.mono;
      size = stylesheet.visual.typography.fontSize.base.size;
    };
    settings = {
      foreground = stylesheet.visual.colors.text.primary;
      background = stylesheet.visual.colors.background.primary;
      cursor = stylesheet.visual.colors.primary."500";

      # Selection colors

      selection\_foreground = stylesheet.visual.colors.text.inverse;
      selection\_background = stylesheet.visual.colors.primary."500";

      # Window styling

      window_padding_width = stylesheet.layout.spacing.md;
      background\_opacity = toString stylesheet.visual.effects.opacity."95";
    };
  };
}
```

## Development

### List available themes

```bash
nix run .#list-themes
```

### Preview a theme

```bash
nix run .#preview-theme dark
nix eval .#packages.cyberpunk --json | jq '.visual.colors'
```

### Validate your configuration

```bash
nix eval .#lib.mkStylesheet --arg theme '"nonexistent"'

# Error: Theme 'nonexistent' not found. Available themes: dark, light, minimal, cyberpunk

```

## Roadmap

- [ ] Additional built-in themes (nord, gruvbox, dracula)
- [ ] Theme validation and linting tools
- [ ] CSS/JSON export for non-Nix applications
- [ ] Documentation site with interactive theme preview
- [ ] Integration examples for popular applications

## Contributing

1. Fork the repository
2. Create a theme in `themes/yourtheme.nix`
3. Test with `nix eval .#lib.mkStylesheet --arg theme '"yourtheme"'`
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

```

#### docs/integration.md {#docs-integration-md}

- **Size:** 0 B
- **Modified:** July 7, 2025

* File is empty*

#### docs/themes.md {#docs-themes-md}

- **Size:** 0 B
- **Modified:** July 7, 2025

* File is empty*

#### docs/tokens.md {#docs-tokens-md}

- **Size:** 0 B
- **Modified:** July 7, 2025

* File is empty*

#### flake.nix {#flake-nix}

- **Size:** 12.1 KB
- **Language:** Nix
- **Lines:** 275
- **Modified:** July 7, 2025

```
{
  description = "CrystalNix - A universal design system for Nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lib = nixpkgs.lib;

          # Auto-discover available themes

          themesDir = ./themes;
          availableThemeFiles = builtins.filter
            (name: lib.hasSuffix ".nix" name && name != "default.nix")
            (builtins.attrNames (builtins.readDir themesDir));
          availableThemes = map (name: lib.removeSuffix ".nix" name) availableThemeFiles;

          # Main stylesheet function

          mkStylesheet = { theme ? "dark", overrides ? { } }:
            let
              baseStylesheet = import ./stylesheets/base.nix { inherit lib; };

              # Validate theme exists

              themeFile = themesDir + "/${theme}.nix";
              themeExists = builtins.pathExists themeFile;

              # Load the selected theme

              selectedTheme =
                if themeExists
                then import themeFile { inherit baseStylesheet lib; }
                else throw "Theme '${theme}' not found. Available themes: ${lib.concatStringsSep ", " availableThemes}";

              # Apply overrides recursively

              finalStylesheet = lib.recursiveUpdate selectedTheme overrides;
            in
            finalStylesheet // {

              # Expose metadata for tooling/discovery

              \_meta = {
                inherit availableThemes;
                currentTheme = theme;
                hasOverrides = overrides != { };
              };
            };
        in
        {

          # Main library functions

          lib = {
            inherit mkStylesheet;
            listThemes = availableThemes;
          };

          # Pre-built themes for easy access

          packages = {
            default = mkStylesheet { };
            dark = mkStylesheet { theme = "dark"; };
            light = mkStylesheet { theme = "light"; };
            minimal = mkStylesheet { theme = "minimal"; };
            cyberpunk = mkStylesheet { theme = "cyberpunk"; };
          };

          # Development shell

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [ nix nixfmt jq ];
            shellHook = ''
              echo "🔮 Welcome to CrystalNix development!"
              echo "Available themes: ${lib.concatStringsSep ", " availableThemes}"
              echo ""
              echo "Testing Commands:"
              echo "  nix run .#validate    # Run all validation tests"
              echo "  nix run .#debug       # Debug dark theme"
              echo "  nix run .#compare     # Compare dark vs light"
              echo ""
              echo "Quick start: nix run .#debug"
            '';
          };

          # Testing and utility apps

          apps = {

            # List available themes

            list-themes = {
              type = "app";
              program = toString (pkgs.writeShellScript "list-themes" ''
                echo "🔮 Available CrystalNix themes:"
                ${lib.concatMapStringsSep "\n" (theme: "echo '  - ${theme}'") availableThemes}
              '');
            };

            # Debug a specific theme (defaults to dark)

            debug = {
              type = "app";
              program = toString (pkgs.writeShellScript "crystalnix-debug" ''
                theme=''${1:-dark}

                echo "🔮 CrystalNix Debug: $theme theme"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                # Check if theme exists

                if ! nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json >/dev/null 2>&1; then
                  echo "❌ Theme '$theme' not found"
                  echo ""
                  echo "Available themes:"
                  ${lib.concatMapStringsSep "\n" (theme: "echo '  - ${theme}'") availableThemes}
                  exit 1
                fi

                # Load the theme and extract key info

                echo "📊 Theme Metadata:"
                nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '._meta | to_entries[] | "  \(.key): \(.value)"'

                echo ""
                echo "🎨 Key Colors:"
                nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors | {
                  "primary-500": .primary."500",
                  "background-primary": .background.primary,
                  "text-primary": .text.primary,
                  "border-primary": .border.primary
                } | to\_entries[] | "  \(.key): \(.value)"'

                echo ""
                echo "📏 Layout Values:"
                nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '.layout | {
                  "spacing-sm": .spacing.sm,
                  "spacing-md": .spacing.md,
                  "spacing-lg": .spacing.lg,
                  "border-radius-md": .borders.radius.md
                } | to\_entries[] | "  \(.key): \(.value)"'

                echo ""
                echo "⚡ Motion Settings:"
                nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '.motion | {
                  "duration-fast": .duration.fast,
                  "duration-normal": .duration.normal,
                  "easing-smooth": .easing.smooth
                } | to\_entries[] | "  \(.key): \(.value)"'

                echo ""
                echo "💡 Usage example:"
                echo "  stylesheet.visual.colors.primary.\"500\"  # $(nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors.primary."500"')"
                echo "  stylesheet.layout.spacing.md            # $(nix eval .#lib.mkStylesheet --arg theme "\"$theme\"" --json | ${pkgs.jq}/bin/jq -r '.layout.spacing.md')"
              '');
            };

            # Compare two themes

            compare = {
              type = "app";
              program = toString (pkgs.writeShellScript "crystalnix-compare" ''
                theme1=''${1:-dark}
                theme2=''${2:-light}

                echo "🔮 Comparing CrystalNix Themes: $theme1 vs $theme2"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                # Get theme data

                t1\_primary=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme1\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors.primary."500"')
                t1\_bg=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme1\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')
                t1\_spacing=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme1\"" --json | ${pkgs.jq}/bin/jq -r '.layout.spacing.md')

                t2\_primary=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme2\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors.primary."500"')
                t2\_bg=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme2\"" --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')
                t2\_spacing=$(nix eval .#lib.mkStylesheet --arg theme "\"$theme2\"" --json | ${pkgs.jq}/bin/jq -r '.layout.spacing.md')

                echo "🎨 Primary Colors:"
                echo "  $theme1: $t1\_primary"
                echo "  $theme2: $t2\_primary"

                echo ""
                echo "🏠 Background Colors:"
                echo "  $theme1: $t1\_bg"
                echo "  $theme2: $t2\_bg"

                echo ""
                echo "📏 Spacing (md):"
                echo "  $theme1: $t1\_spacing"
                echo "  $theme2: $t2\_spacing"

                # Check if they're different

                if [ "$t1_primary" != "$t2_primary" ] || [ "$t1_bg" != "$t2_bg" ]; then
                  echo ""
                  echo "✅ Themes are different - switching will change your appearance"
                else
                  echo ""
                  echo "⚠️  Themes appear identical - you may need to check theme definitions"
                fi
              '');
            };

            # Validate all functionality

            validate = {
              type = "app";
              program = toString (pkgs.writeShellScript "crystalnix-validate" ''
                set -e
                echo "🔮 CrystalNix Validation Tests"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                errors=0

                # Test 1: Check all themes load

                echo "📋 Test 1: Theme Loading"
                ${lib.concatMapStringsSep "\n" (theme: ''
                  echo -n "  Testing ${theme}... "
                  if nix eval .#lib.mkStylesheet --arg theme '"${theme}"' --json >/dev/null 2>&1; then
                    echo "✅"
                  else
                    echo "❌"
                    ((errors++))
                  fi
                '') availableThemes}

                # Test 2: Check themes are different

                echo ""
                echo "📋 Test 2: Theme Differences"
                dark\_bg=$(nix eval .#lib.mkStylesheet --arg theme '"dark"' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')
                light\_bg=$(nix eval .#lib.mkStylesheet --arg theme '"light"' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')

                echo "  Dark background: $dark\_bg"
                echo "  Light background: $light\_bg"

                if [ "$dark_bg" != "$light_bg" ]; then
                  echo "  ✅ Themes have different backgrounds"
                else
                  echo "  ❌ Themes have identical backgrounds"
                  ((errors++))
                fi

                # Test 3: Check overrides work

                echo ""
                echo "📋 Test 3: Override Functionality"
                original=$(nix eval .#lib.mkStylesheet --arg theme '"dark"' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.primary."500"')
                override=$(nix eval .#lib.mkStylesheet --arg theme '"dark"' --arg overrides '{ visual.colors.primary."500" = "#ff0000"; }' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.primary."500"')

                echo "  Original: $original"
                echo "  Override: $override"

                if [ "$original" != "$override" ] && [ "$override" = "#ff0000" ]; then
                  echo "  ✅ Overrides working"
                else
                  echo "  ❌ Overrides not working"
                  ((errors++))
                fi

                echo ""
                if [ $errors -eq 0 ]; then
                  echo "🎉 All tests passed! CrystalNix is working correctly."
                  echo ""
                  echo "Try: nix run .#debug dark"
                else
                  echo "💥 $errors test(s) failed"
                  exit 1
                fi
              '');
            };
          };
        }) // {

      # System-agnostic lib for use in other flakes

      lib = {
        mkStylesheet = { theme ? "dark", overrides ? { } }:
          let
            lib = nixpkgs.lib;
            baseStylesheet = import ./stylesheets/base.nix { inherit lib; };
            themeFile = ./themes + "/${theme}.nix";
            selectedTheme = import themeFile { inherit baseStylesheet lib; };
            finalStylesheet = lib.recursiveUpdate selectedTheme overrides;
          in
          finalStylesheet // {
            \_meta = { currentTheme = theme; hasOverrides = overrides != { }; };
          };
      };
    };
}

```

#### stylesheets/base.nix {#stylesheets-base-nix}

- **Size:** 11.8 KB
- **Language:** Nix
- **Lines:** 560
- **Modified:** July 7, 2025

```
{ lib }:
rec {

  # Helper functions for common transformations

  helpers = {

    # Color utilities

    rgba = r: g: b: a: "rgba(${toString r}, ${toString g}, ${toString b}, ${toString a})";
    hex = color: color;

    # Unit utilities

    px = value: "${toString value}px";
    rem = value: "${toString value}rem";
    em = value: "${toString value}em";
    percent = value: "${toString value}%";

    # Time utilities

    ms = value: "${toString value}ms";
    s = value: "${toString value}s";

    # CSS function helpers

    cubicBezier = x1: y1: x2: y2: "cubic-bezier(${toString x1}, ${toString y1}, ${toString x2}, ${toString y2})";

    # Scale generators

    generateScale = base: multiplier: steps:
      lib.listToAttrs (lib.imap0
        (i: \_: {
          name = toString i;
          value = base \* (lib.pow multiplier i);
        })
        (lib.range 0 (steps - 1)));
  };

  # Layout System - spacing, sizing, borders

  layout = {

    # Spacing scale (in pixels, can be converted with helpers)

    spacing = {
      "0" = 0;
      "1" = 4;
      "2" = 8;
      "3" = 12;
      "4" = 16;
      "5" = 20;
      "6" = 24;
      "8" = 32;
      "10" = 40;
      "12" = 48;
      "16" = 64;
      "20" = 80;
      "24" = 96;
      "32" = 128;
      "40" = 160;
      "48" = 192;
      "56" = 224;
      "64" = 256;

      # Semantic aliases

      xs = 4;
      sm = 8;
      md = 16;
      lg = 32;
      xl = 64;
      xxl = 128;
    };

    # Border system

    borders = {
      width = {
        none = 0;
        thin = 1;
        normal = 2;
        thick = 4;
        heavy = 8;
      };

      radius = {
        none = 0;
        sm = 4;
        md = 8;
        lg = 16;
        xl = 24;
        full = 9999;
      };

      style = {
        solid = "solid";
        dashed = "dashed";
        dotted = "dotted";
        none = "none";
      };
    };

    # Size scale

    size = {
      "0" = 0;
      "1" = 4;
      "2" = 8;
      "4" = 16;
      "6" = 24;
      "8" = 32;
      "10" = 40;
      "12" = 48;
      "16" = 64;
      "20" = 80;
      "24" = 96;
      "32" = 128;
      "40" = 160;
      "48" = 192;
      "56" = 224;
      "64" = 256;
      "72" = 288;
      "80" = 320;
      "96" = 384;
    };

    # Breakpoints (for responsive applications)

    breakpoints = {
      xs = 480;
      sm = 768;
      md = 1024;
      lg = 1280;
      xl = 1536;
      xxl = 1920;
    };
  };

  # Visual System - colors, effects, typography

  visual = {

    # Color palette - base color scales

    colors = {

      # Grays/Neutrals

      slate = {
        "50" = "#f8fafc";
        "100" = "#f1f5f9";
        "200" = "#e2e8f0";
        "300" = "#cbd5e1";
        "400" = "#94a3b8";
        "500" = "#64748b";
        "600" = "#475569";
        "700" = "#334155";
        "800" = "#1e293b";
        "900" = "#0f172a";
        "950" = "#020617";
      };

      gray = {
        "50" = "#f9fafb";
        "100" = "#f3f4f6";
        "200" = "#e5e7eb";
        "300" = "#d1d5db";
        "400" = "#9ca3af";
        "500" = "#6b7280";
        "600" = "#4b5563";
        "700" = "#374151";
        "800" = "#1f2937";
        "900" = "#111827";
        "950" = "#030712";
      };

      # Brand Colors

      red = {
        "50" = "#fef2f2";
        "100" = "#fee2e2";
        "200" = "#fecaca";
        "300" = "#fca5a5";
        "400" = "#f87171";
        "500" = "#ef4444";
        "600" = "#dc2626";
        "700" = "#b91c1c";
        "800" = "#991b1b";
        "900" = "#7f1d1d";
        "950" = "#450a0a";
      };

      orange = {
        "50" = "#fff7ed";
        "100" = "#ffedd5";
        "200" = "#fed7aa";
        "300" = "#fdba74";
        "400" = "#fb923c";
        "500" = "#f97316";
        "600" = "#ea580c";
        "700" = "#c2410c";
        "800" = "#9a3412";
        "900" = "#7c2d12";
        "950" = "#431407";
      };

      yellow = {
        "50" = "#fefce8";
        "100" = "#fef9c3";
        "200" = "#fef08a";
        "300" = "#fde047";
        "400" = "#facc15";
        "500" = "#eab308";
        "600" = "#ca8a04";
        "700" = "#a16207";
        "800" = "#854d0e";
        "900" = "#713f12";
        "950" = "#422006";
      };

      green = {
        "50" = "#f0fdf4";
        "100" = "#dcfce7";
        "200" = "#bbf7d0";
        "300" = "#86efac";
        "400" = "#4ade80";
        "500" = "#22c55e";
        "600" = "#16a34a";
        "700" = "#15803d";
        "800" = "#166534";
        "900" = "#14532d";
        "950" = "#052e16";
      };

      blue = {
        "50" = "#eff6ff";
        "100" = "#dbeafe";
        "200" = "#bfdbfe";
        "300" = "#93c5fd";
        "400" = "#60a5fa";
        "500" = "#3b82f6";
        "600" = "#2563eb";
        "700" = "#1d4ed8";
        "800" = "#1e40af";
        "900" = "#1e3a8a";
        "950" = "#172554";
      };

      purple = {
        "50" = "#faf5ff";
        "100" = "#f3e8ff";
        "200" = "#e9d5ff";
        "300" = "#d8b4fe";
        "400" = "#c084fc";
        "500" = "#a855f7";
        "600" = "#9333ea";
        "700" = "#7c3aed";
        "800" = "#6b21a8";
        "900" = "#581c87";
        "950" = "#3b0764";
      };

      pink = {
        "50" = "#fdf2f8";
        "100" = "#fce7f3";
        "200" = "#fbcfe8";
        "300" = "#f9a8d4";
        "400" = "#f472b6";
        "500" = "#ec4899";
        "600" = "#db2777";
        "700" = "#be185d";
        "800" = "#9d174d";
        "900" = "#831843";
        "950" = "#500724";
      };

      # Special colors

      white = "#ffffff";
      black = "#000000";
      transparent = "transparent";
      current = "currentColor";
    };

    # Typography system

    typography = {
      fontFamily = {
        sans = [
          "ui-sans-serif"
          "system-ui"
          "-apple-system"
          "BlinkMacSystemFont"
          "Segoe UI"
          "Roboto"
          "Helvetica Neue"
          "Arial"
          "Noto Sans"
          "sans-serif"
          "Apple Color Emoji"
          "Segoe UI Emoji"
          "Segoe UI Symbol"
          "Noto Color Emoji"
        ];

        serif = [
          "ui-serif"
          "Georgia"
          "Cambria"
          "Times New Roman"
          "Times"
          "serif"
        ];

        mono = [
          "ui-monospace"
          "SFMono-Regular"
          "Menlo"
          "Monaco"
          "Consolas"
          "Liberation Mono"
          "Courier New"
          "monospace"
        ];
      };

      fontSize = {
        xs = { size = 12; lineHeight = 16; };
        sm = { size = 14; lineHeight = 20; };
        base = { size = 16; lineHeight = 24; };
        lg = { size = 18; lineHeight = 28; };
        xl = { size = 20; lineHeight = 28; };
        "2xl" = { size = 24; lineHeight = 32; };
        "3xl" = { size = 30; lineHeight = 36; };
        "4xl" = { size = 36; lineHeight = 40; };
        "5xl" = { size = 48; lineHeight = 48; };
        "6xl" = { size = 60; lineHeight = 60; };
        "7xl" = { size = 72; lineHeight = 72; };
        "8xl" = { size = 96; lineHeight = 96; };
        "9xl" = { size = 128; lineHeight = 128; };
      };

      fontWeight = {
        thin = 100;
        extralight = 200;
        light = 300;
        normal = 400;
        medium = 500;
        semibold = 600;
        bold = 700;
        extrabold = 800;
        black = 900;
      };

      lineHeight = {
        none = 1;
        tight = 1.25;
        snug = 1.375;
        normal = 1.5;
        relaxed = 1.625;
        loose = 2;
      };

      letterSpacing = {
        tighter = "-0.05em";
        tight = "-0.025em";
        normal = "0em";
        wide = "0.025em";
        wider = "0.05em";
        widest = "0.1em";
      };
    };

    # Visual effects

    effects = {

      # Shadows

      shadow = {
        none = "none";
        sm = "0 1px 2px 0 rgba(0, 0, 0, 0.05)";
        base = "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)";
        md = "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)";
        lg = "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)";
        xl = "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)";
        "2xl" = "0 25px 50px -12px rgba(0, 0, 0, 0.25)";
        inner = "inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)";
      };

      # Opacity levels

      opacity = {
        "0" = 0;
        "5" = 0.05;
        "10" = 0.1;
        "20" = 0.2;
        "25" = 0.25;
        "30" = 0.3;
        "40" = 0.4;
        "50" = 0.5;
        "60" = 0.6;
        "70" = 0.7;
        "75" = 0.75;
        "80" = 0.8;
        "90" = 0.9;
        "95" = 0.95;
        "100" = 1;
      };

      # Blur effects

      blur = {
        none = "none";
        sm = "blur(4px)";
        base = "blur(8px)";
        md = "blur(12px)";
        lg = "blur(16px)";
        xl = "blur(24px)";
        "2xl" = "blur(40px)";
        "3xl" = "blur(64px)";
      };

      # Backdrop blur

      backdropBlur = {
        none = "none";
        sm = "blur(4px)";
        base = "blur(8px)";
        md = "blur(12px)";
        lg = "blur(16px)";
        xl = "blur(24px)";
        "2xl" = "blur(40px)";
        "3xl" = "blur(64px)";
      };
    };
  };

  # Motion System - animations, transitions, timing

  motion = {

    # Duration scales (in milliseconds)

    duration = {
      "0" = 0;
      "75" = 75;
      "100" = 100;
      "150" = 150;
      "200" = 200;
      "300" = 300;
      "500" = 500;
      "700" = 700;
      "1000" = 1000;

      # Semantic durations

      instant = 0;
      fast = 150;
      normal = 250;
      slow = 400;
      slower = 700;
    };

    # Easing functions

    easing = {
      linear = "linear";

      # Ease variants

      ease = "ease";
      easeIn = "ease-in";
      easeOut = "ease-out";
      easeInOut = "ease-in-out";

      # Custom beziers

      smooth = helpers.cubicBezier 0.05 0.9 0.1 1.05;
      snappy = helpers.cubicBezier 0.25 0.46 0.45 0.94;
      bounce = helpers.cubicBezier 0.68 (-0.55) 0.265 1.55;

      # Material Design curves

      standard = helpers.cubicBezier 0.4 0.0 0.2 1;
      decelerate = helpers.cubicBezier 0.0 0.0 0.2 1;
      accelerate = helpers.cubicBezier 0.4 0.0 1 1;
    };

    # Delays

    delay = {
      "0" = 0;
      "75" = 75;
      "100" = 100;
      "150" = 150;
      "200" = 200;
      "300" = 300;
      "500" = 500;
      "700" = 700;
      "1000" = 1000;
    };
  };

  # Interaction System - input, cursors, states

  interaction = {

    # Cursor styles

    cursor = {
      auto = "auto";
      default = "default";
      pointer = "pointer";
      wait = "wait";
      text = "text";
      move = "move";
      help = "help";
      notAllowed = "not-allowed";
      grab = "grab";
      grabbing = "grabbing";
      crosshair = "crosshair";

      # Timeout for hiding cursor (in seconds)

      timeout = 3;
    };

    # Input settings

    input = {
      mouse = {
        sensitivity = 0.5;
        acceleration = 1.0;
      };

      keyboard = {
        repeatRate = 25;
        repeatDelay = 600;
      };

      touchpad = {
        naturalScroll = true;
        tapToClick = true;
        scrollFactor = 1.0;
      };
    };

    # Focus management

    focus = {
      outlineWidth = 2;
      outlineOffset = 2;
      outlineStyle = "solid";

      # Ring effects (for focus indicators)

      ring = {
        width = {
          "0" = 0;
          "1" = 1;
          "2" = 2;
          "4" = 4;
          "8" = 8;
        };

        offset = {
          "0" = 0;
          "1" = 1;
          "2" = 2;
          "4" = 4;
          "8" = 8;
        };
      };
    };

    # Hover and state timing

    states = {
      hoverDelay = 100;
      activeDelay = 0;
      focusDelay = 0;
    };
  };

  # Z-index scale for layering

  zIndex = {
    auto = "auto";
    "0" = 0;
    "10" = 10;
    "20" = 20;
    "30" = 30;
    "40" = 40;
    "50" = 50;

    # Semantic layers

    base = 0;
    overlay = 1000;
    modal = 2000;
    popover = 3000;
    tooltip = 4000;
    notification = 5000;
  };
}

```

#### themes/cyberpunk.nix {#themes-cyberpunk-nix}

- **Size:** 573 B
- **Language:** Nix
- **Lines:** 17
- **Modified:** July 7, 2025

```
{ baseStylesheet, lib }:
let
  neon = { pink = "#ff2d92"; cyan = "#00f5ff"; purple = "#9945ff"; };
in
baseStylesheet // {
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = { "500" = neon.cyan; "400" = "#33f7ff"; "600" = "#00d4e6"; };
      accent = neon.pink;
      background = { primary = "#0a0a0a"; secondary = "#1a1a2e"; };
      text = { primary = neon.cyan; secondary = "#e94560"; };
      border = { primary = neon.purple; focus = neon.pink; };
      shadow = { primary = "rgba(0, 245, 255, 0.3)"; };
    };
  };
}

```

#### themes/dark.nix {#themes-dark-nix}

- **Size:** 1.0 KB
- **Language:** Nix
- **Lines:** 34
- **Modified:** July 7, 2025

```
{ baseStylesheet, lib }:
baseStylesheet // {
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = baseStylesheet.visual.colors.blue;
      secondary = baseStylesheet.visual.colors.slate;
      accent = baseStylesheet.visual.colors.blue."400";

      background = {
        primary = baseStylesheet.visual.colors.slate."900";
        secondary = baseStylesheet.visual.colors.slate."800";
        tertiary = baseStylesheet.visual.colors.slate."700";
      };

      text = {
        primary = baseStylesheet.visual.colors.slate."50";
        secondary = baseStylesheet.visual.colors.slate."300";
        tertiary = baseStylesheet.visual.colors.slate."400";
      };

      border = {
        primary = baseStylesheet.visual.colors.slate."600";
        secondary = baseStylesheet.visual.colors.slate."700";
        focus = baseStylesheet.visual.colors.blue."500";
      };

      shadow = {
        primary = "rgba(0, 0, 0, 0.9)";
        secondary = "rgba(0, 0, 0, 0.6)";
      };
    };
  };
}

```

#### themes/light.nix {#themes-light-nix}

- **Size:** 0 B
- **Modified:** July 7, 2025

* File is empty*

#### themes/minimal.nix {#themes-minimal-nix}

- **Size:** 581 B
- **Language:** Nix
- **Lines:** 20
- **Modified:** July 7, 2025

```
{ baseStylesheet, lib }:
baseStylesheet // {
  layout = baseStylesheet.layout // {
    spacing = baseStylesheet.layout.spacing // {
      sm = 4;
      md = 8;
      lg = 16;
    };
  };
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = baseStylesheet.visual.colors.slate;
      background = { primary = "#fafafa"; secondary = "#f5f5f5"; };
      text = { primary = "#333333"; secondary = "#666666"; };
      border = { primary = "#e0e0e0"; focus = "#888888"; };
      shadow = { primary = "rgba(0, 0, 0, 0.08)"; };
    };
  };
}

```

