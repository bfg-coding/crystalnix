
# 🔮 CrystalNix

> A universal design system for Nix configurations

CrystalNix is a powerful design system that transforms raw theme values into format-specific outputs for any application. Define your colors, spacing, and typography once, then use them everywhere - from Hyprland to CSS to terminal emulators.

## ✨ Key Features

- **🎨 Universal Theming**: One theme definition works everywhere
- **📱 Multi-Format Output**: Colors as hex, conf, RGB; spacing as px, rem, raw
- **🔧 Application-Ready**: Built-in support for Hyprland, Kitty, i3, CSS, and more
- **🧩 Extensible**: Easy to add new formats and transform functions
- **🎯 Type-Safe**: Schema-driven validation ensures consistent outputs
- **⚡ Flake-Based**: Modern Nix flake for easy dependency management

## 🚀 Quick Start

### Using as a Flake

```nix
{
  inputs.crystalnix.url = "github:you/crystalnix";
  
  outputs = { crystalnix, ... }: {
    # Use built-in themes
    darkTheme = crystalnix.lib.mkStylesheet { theme = "dark"; };
    lightTheme = crystalnix.lib.mkStylesheet { theme = "light"; };
    
    # Or create custom theme
    myTheme = crystalnix.lib.mkStylesheet { 
      theme = "dark"; 
      overrides = {
        colors.primary."500" = "#ff6b6b";
      };
    };
  };
}
```

### Usage Examples

```nix
# Colors in different formats
stylesheet.colors.primary."500".hex     # "#3b82f6" (CSS)
stylesheet.colors.primary."500".conf    # "3b82f6"  (Hyprland)
stylesheet.colors.primary."500".rgb     # { r = 59; g = 130; b = 246; }

# Spacing in different units  
stylesheet.spacing.md.px                # "16px"
stylesheet.spacing.md.rem               # "1rem"
stylesheet.spacing.md.raw               # 16

# Typography formats
stylesheet.typography.fontFamily.sans.css    # "Inter, system-ui, ..."
stylesheet.typography.fontFamily.sans.single # "Inter"
```

## 📁 Project Structure

```
crystalnix/
├── flake.nix                    # Main flake entry point
├── lib/                         # Core design system library
│   ├── default.nix             # Main exports (processTheme, etc.)
│   ├── utils.nix               # Helper functions (hex conversion, etc.)
│   ├── defaults.nix            # Configuration defaults
│   ├── schema.nix              # Transform schema mapping
│   ├── processor.nix           # Core theme processor
│   ├── transforms/             # Transform functions
│   │   ├── default.nix         # Transform registry
│   │   ├── colors.nix          # Color transforms (hex, conf, rgb)
│   │   ├── spacing.nix         # Spacing transforms (px, rem, raw)
│   │   ├── typography.nix      # Typography transforms
│   │   ├── motion.nix          # Motion/timing transforms
│   │   └── effects.nix         # Effects transforms (opacity, shadows)
│   └── themes/                 # Built-in themes
│       ├── default.nix         # Theme registry
│       ├── dark.nix            # Dark theme (raw values)
│       └── light.nix           # Light theme (raw values)
└── README.md                   # This file
```

## 🎨 Creating Themes

Themes contain only raw values - the system handles all format conversions:

```nix
# mytheme.nix
{
  colors = {
    primary = {
      "500" = "#3b82f6";    # Raw hex color
    };
    background = {
      primary = "#0f172a";
    };
  };
  
  spacing = {
    md = 16;                # Raw pixel value
    lg = 32;
  };
  
  typography = {
    fontFamily = {
      sans = ["Inter" "system-ui" "sans-serif"];  # Raw font list
    };
    fontSize = {
      base = 16;            # Raw pixel size
    };
  };
}
```

The system automatically transforms these into:

```nix
# After processing
{
  colors.primary."500" = {
    hex = "#3b82f6";
    conf = "3b82f6";
    rgb = { r = 59; g = 130; b = 246; };
    rgbString = "59,130,246";
  };
  
  spacing.md = {
    px = "16px";
    rem = "1rem";
    raw = 16;
  };
  
  typography.fontFamily.sans = {
    css = "Inter, system-ui, sans-serif";
    single = "Inter";
    raw = ["Inter" "system-ui" "sans-serif"];
  };
}
```

## 🔧 Application Configs

### Hyprland

```nix
{
  general = {
    col.active_border = stylesheet.colors.primary."500".conf;
    col.inactive_border = stylesheet.colors.border.primary.conf;
    border_size = stylesheet.borders.width.normal.raw;
    gaps_in = stylesheet.spacing.sm.raw;
    gaps_out = stylesheet.spacing.md.raw;
  };
  
  decoration = {
    rounding = stylesheet.borders.radius.md.raw;
  };
}
```

### Kitty Terminal

```nix
{
  background = stylesheet.colors.background.primary.hex;
  foreground = stylesheet.colors.text.primary.hex;
  cursor = stylesheet.colors.primary."500".hex;
  font_family = stylesheet.typography.fontFamily.mono.single;
  font_size = stylesheet.typography.fontSize.base.raw;
}
```

### CSS Variables

```css
:root {
  --color-primary: #{stylesheet.colors.primary."500".hex};
  --spacing-md: #{stylesheet.spacing.md.px};
  --font-family: #{stylesheet.typography.fontFamily.sans.css};
  --duration-fast: #{stylesheet.motion.duration.fast.ms};
}
```

### i3/Sway

```nix
{
  set = {
    "$bg" = stylesheet.colors.background.primary.hex;
    "$fg" = stylesheet.colors.text.primary.hex;
    "$accent" = stylesheet.colors.primary."500".hex;
  };
  
  gaps = {
    inner = stylesheet.spacing.sm.raw;
    outer = stylesheet.spacing.xs.raw;
  };
}
```

## 🧪 Development & Testing

### Available Commands

```bash
# List available themes
nix run .#list-themes

# Debug a theme (shows key values and formats)
nix run .#debug dark

# Compare two themes
nix run .#compare dark light

# Test format outputs
nix run .#formats dark

# Run validation tests
nix run .#validate

# Development shell
nix develop
```

### Built-in Themes

- **`dark`**: Modern dark theme optimized for terminals and low-light use
- **`light`**: Clean light theme perfect for documentation and professional apps

### Theme Extending

```nix
# Extend a built-in theme
extendedTheme = crystalnix.lib.mkStylesheet {
  theme = "dark";
  overrides = {
    colors.primary."500" = "#ff6b6b";  # Custom accent color
    spacing.custom = 48;                # Add custom values
  };
};

# Or using the helper function
customTheme = crystalnix.lib.designSystem.extendTheme 
  crystalnix.lib.designSystem.themes.dark
  { colors.primary."500" = "#ff6b6b"; };
```

## 🎯 Transform System

The transform system automatically converts raw theme values into multiple formats:

### Color Transforms
- **`hex`**: `"#3b82f6"` (CSS standard)
- **`conf`**: `"3b82f6"` (Config files, Hyprland)
- **`rgb`**: `{ r = 59; g = 130; b = 246; }` (Object format)
- **`rgbString`**: `"59,130,246"` (String format)

### Spacing Transforms
- **`px`**: `"16px"` (CSS pixels)
- **`rem`**: `"1rem"` (Relative units)
- **`raw`**: `16` (Bare number)

### Typography Transforms
- **`css`**: `"Inter, system-ui, sans-serif"` (CSS font stack)
- **`single`**: `"Inter"` (Single font for limited configs)
- **`raw`**: `["Inter" "system-ui" "sans-serif"]` (Array format)

### Motion Transforms
- **`ms`**: `"300ms"` (CSS milliseconds)
- **`s`**: `"0.3s"` (CSS seconds)
- **`raw`**: `300` (Bare number)

## 🔌 Extending the System

### Adding New Transforms

```nix
# lib/transforms/myTransform.nix
{ lib, utils, defaults }:

{
  # Transform function takes raw value, returns format object
  myTransform = value: {
    raw = value;
    custom = "custom-${toString value}";
    # ... other formats
  };
}
```

### Adding New Schema Mappings

```nix
# lib/schema.nix
{
  # ... existing mappings
  myNewSection = "myTransform";  # Apply myTransform to this path
}
```

### Adding New Themes

```nix
# themes/cyberpunk.nix
{
  colors = {
    primary."500" = "#00ff41";  # Matrix green
    background.primary = "#0d1421";
    # ... rest of theme
  };
  # ... other theme properties
}
```

## 📖 API Reference

### Main Functions

- **`processTheme rawTheme`**: Transform raw theme into stylesheet
- **`mkStylesheet { theme, overrides }`**: Process theme with optional overrides
- **`extendTheme baseTheme overrides`**: Merge themes recursively

### Built-in Themes

- **`themes.dark`**: Dark theme optimized for terminals
- **`themes.light`**: Light theme for documentation/professional use

### Utilities

- **`utils.hexToRgb`**: Convert hex to RGB components
- **`utils.toPx`**: Convert number to pixel string
- **`utils.toRem`**: Convert pixels to rem units
- **`utils.fontListToCss`**: Convert font array to CSS string

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your changes (transforms, themes, etc.)
4. Run validation: `nix run .#validate`
5. Submit a pull request

### Guidelines

- Keep themes minimal (raw values only)
- Add transform tests for new formats
- Update documentation for new features
- Follow the existing naming conventions

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by design systems like Tailwind CSS and Material Design
- Built with the power and flexibility of Nix
- Thanks to the Nix community for feedback and contributions

---

**🔮 Transform your configurations with CrystalNix - one theme, infinite possibilities.**
