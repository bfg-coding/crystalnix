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
      gaps_in = stylesheet.layout.spacing.sm;              # 8
      gaps_out = stylesheet.layout.spacing.md;             # 16  
      border_size = stylesheet.layout.borders.width.normal; # 2
      "col.active_border" = stylesheet.visual.colors.primary."500";
      "col.inactive_border" = stylesheet.visual.colors.border.primary;
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
      * {
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

      #workspaces button.active {
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
      selection_foreground = stylesheet.visual.colors.text.inverse;
      selection_background = stylesheet.visual.colors.primary."500";
      
      # Window styling
      window_padding_width = stylesheet.layout.spacing.md;
      background_opacity = toString stylesheet.visual.effects.opacity."95";
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
