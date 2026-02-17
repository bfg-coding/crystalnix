{ lib }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR SYSTEM - Ratpoison Terminal Palette
  # ═══════════════════════════════════════════════════════════════════════════

  colors = {
    # ═══════════════════════════════════════════════════════════════════════════
    # RATPOISON CORE COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    # Primary brand color (Classic Terminal Green)
    primary = {
      "50" = "#d1fae5";
      "100" = "#a7f3d0";
      "200" = "#6ee7b7";
      "300" = "#34d399";
      "400" = "#10b981";
      "500" = "#00ff00"; # Classic terminal green
      "600" = "#00cc00";
      "700" = "#009900";
      "800" = "#006600";
      "900" = "#003300";
      "950" = "#001a00";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # RATPOISON SIGNATURE COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    # Terminal color collection
    terminal = {
      # Standard ANSI colors (green-tinted)
      black = "#000000";
      red = "#ff6b6b";
      green = "#00ff00"; # The signature green
      yellow = "#f0e68c";
      blue = "#6b8aff";
      magenta = "#ff6bff";
      cyan = "#00ffff";
      white = "#cccccc";
      
      # Bright variants
      brightBlack = "#4d4d4d";
      brightRed = "#ff9999";
      brightGreen = "#66ff66";
      brightYellow = "#ffff99";
      brightBlue = "#99b3ff";
      brightMagenta = "#ff99ff";
      brightCyan = "#99ffff";
      brightWhite = "#ffffff";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # BACKGROUNDS (Pure black terminal aesthetic)
    # ═══════════════════════════════════════════════════════════════════════════

    bg = {
      primary = "#000000"; # Pure black (main background)
      secondary = "#0d0d0d"; # Slightly elevated
      tertiary = "#1a1a1a"; # Panels/cards
      quaternary = "#262626"; # Higher surfaces
      highlight = "#333333"; # Subtle highlight
      float = "#000000"; # Floating windows
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # TEXT COLORS (Green hierarchy for terminal feel)
    # ═══════════════════════════════════════════════════════════════════════════

    fg = {
      primary = "#00ff00"; # Main text (bright green)
      secondary = "#00cc00"; # Secondary text
      tertiary = "#009900"; # Muted text
      quaternary = "#006600"; # Disabled text
      dark = "#003300"; # Very muted
      comment = "#004400"; # Comments (dim green)
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SEMANTIC COLORS (Terminal-inspired)
    # ═══════════════════════════════════════════════════════════════════════════

    # Success (Terminal Green)
    success = {
      "50" = "#d1fae5";
      "100" = "#a7f3d0";
      "200" = "#6ee7b7";
      "300" = "#34d399";
      "400" = "#10b981";
      "500" = "#00ff00"; # Terminal green
      "600" = "#00cc00";
      "700" = "#009900";
      "800" = "#006600";
      "900" = "#003300";
    };

    # Warning (Amber/Yellow - kept for contrast)
    warning = {
      "50" = "#fefce8";
      "100" = "#fef9c3";
      "200" = "#fef08a";
      "300" = "#fde047";
      "400" = "#facc15";
      "500" = "#f0e68c"; # Khaki/yellow (muted for terminal)
      "600" = "#ca8a04";
      "700" = "#a16207";
      "800" = "#854d0e";
      "900" = "#713f12";
    };

    # Error (Terminal Red - kept for usability)
    error = {
      "50" = "#fef2f2";
      "100" = "#fee2e2";
      "200" = "#fecaca";
      "300" = "#fca5a5";
      "400" = "#f87171";
      "500" = "#ff6b6b"; # Softer terminal red
      "600" = "#dc2626";
      "700" = "#b91c1c";
      "800" = "#991b1b";
      "900" = "#7f1d1d";
    };

    # Info (Cyan)
    info = {
      "50" = "#ecfeff";
      "100" = "#cffafe";
      "200" = "#a5f3fc";
      "300" = "#67e8f9";
      "400" = "#22d3ee";
      "500" = "#00ffff"; # Cyan for terminal contrast
      "600" = "#0891b2";
      "700" = "#0e7490";
      "800" = "#155e75";
      "900" = "#164e63";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # UTILITY COLOR PALETTES
    # ═══════════════════════════════════════════════════════════════════════════

    # Grayscale with green tint
    slate = {
      "50" = "#f0fdf4";
      "100" = "#dcfce7";
      "200" = "#bbf7d0";
      "300" = "#86efac";
      "400" = "#4ade80";
      "500" = "#22c55e";
      "600" = "#16a34a";
      "700" = "#15803d";
      "800" = "#14532d";
      "900" = "#052e16";
      "950" = "#042f1f";
    };

    # Dark grays (green-tinted blacks)
    zinc = {
      "50" = "#fafafa";
      "100" = "#f4f4f5";
      "200" = "#e4e4e7";
      "300" = "#d4d4d8";
      "400" = "#a1a1aa";
      "500" = "#71717a";
      "600" = "#52525b";
      "700" = "#3f3f46";
      "800" = "#27272a";
      "900" = "#18181b";
      "950" = "#000000"; # Pure black for zinc darkest
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # ACCENT COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    # Secondary accent (Cyan)
    secondary = {
      "50" = "#ecfeff";
      "100" = "#cffafe";
      "200" = "#a5f3fc";
      "300" = "#67e8f9";
      "400" = "#22d3ee";
      "500" = "#00ffff"; # Cyan accent
      "600" = "#0891b2";
      "700" = "#0e7490";
      "800" = "#155e75";
      "900" = "#164e63";
      "950" = "#083344";
    };

    # Accent color (Magenta for contrast)
    accent = {
      "50" = "#fdf4ff";
      "100" = "#fae8ff";
      "200" = "#f5d0fe";
      "300" = "#f0abfc";
      "400" = "#e879f9";
      "500" = "#d946ef"; # Magenta for variety
      "600" = "#c026d3";
      "700" = "#a21caf";
      "800" = "#86198f";
      "900" = "#701a75";
      "950" = "#4a044e";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SURFACE COLORS (Black elevation)
    # ═══════════════════════════════════════════════════════════════════════════

    surface = {
      "0" = "#000000"; # Base level (pure black)
      "1" = "#0d0d0d"; # Slightly elevated
      "2" = "#1a1a1a"; # Cards, modals
      "3" = "#262626"; # Dropdowns, tooltips
      "4" = "#333333"; # Highest elevation
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # UTILITY COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    utility = {
      # Border utilities
      border = {
        subtle = "#1a1a1a"; # Very subtle borders
        default = "#262626"; # Standard borders  
        emphasis = "#333333"; # Emphasized borders
        strong = "#4d4d4d"; # Strong borders
        inactive = "#0d0d0d"; # Inactive borders
        focus = "#00ff00"; # Focus borders (green)
      };

      # Text utilities
      text = {
        ghost = "#003300"; # Very muted text
        muted = "#006600"; # Muted text
        subtle = "#009900"; # Subtle text
        default = "#00ff00"; # Default text (bright green)
        emphasis = "#66ff66"; # Emphasized text (brighter)
        accent = "#00ffff"; # Accent text (cyan)
      };

      # Overlay utilities
      overlay = {
        subtle = "#00000008"; # 3% overlay
        light = "#00000020"; # 12% overlay  
        medium = "#00000040"; # 25% overlay
        heavy = "#00000080"; # 50% overlay
      };

      # Selection colors
      selection = {
        bg = "#003300"; # Selection background (dark green)
        fg = "#00ff00"; # Selection text (bright green)
      };
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SEMANTIC ALIASES
    # ═══════════════════════════════════════════════════════════════════════════

    background = {
      primary = "#000000"; # Main app background (pure black)
      secondary = "#0d0d0d"; # Card/panel background
      tertiary = "#1a1a1a"; # Elevated surfaces
      quaternary = "#262626"; # Highest surfaces
      inverse = "#00ff00"; # Green background (for contrast)
      float = "#000000"; # Floating windows
    };

    text = {
      primary = "#00ff00"; # Main text (bright green)
      secondary = "#00cc00"; # Muted text
      tertiary = "#006600"; # Disabled text
      inverse = "#000000"; # Black text (on green)
      accent = "#00ffff"; # Link/accent text (cyan)
      ghost = "#003300"; # Very subtle text
      comment = "#004400"; # Comments
    };

    border = {
      primary = "#262626"; # Default borders
      secondary = "#1a1a1a"; # Subtle borders
      tertiary = "#0d0d0d"; # Very subtle borders
      focus = "#00ff00"; # Focus outlines (green)
      error = "#ff6b6b"; # Error borders
      inactive = "#0d0d0d"; # Inactive borders
      emphasis = "#333333"; # Emphasized borders
      active = "#00ff00"; # Active borders (green)
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SPACING SYSTEM (identical to other themes)
  # ═══════════════════════════════════════════════════════════════════════════

  spacing = {
    # Base scale (4px grid)
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
    xs = 4; # Extra small
    sm = 8; # Small  
    md = 16; # Medium (base)
    lg = 32; # Large
    xl = 64; # Extra large
    xxl = 128; # Double extra large
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BORDER SYSTEM (identical to other themes)
  # ═══════════════════════════════════════════════════════════════════════════

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
      full = 9999; # For pills/circles
    };

    style = {
      solid = "solid";
      dashed = "dashed";
      dotted = "dotted";
      none = "none";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TYPOGRAPHY SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  typography = {
    # Font families - emphasizing monospace for terminal feel
    fontFamily = {
      sans = [
        "Inter"
        "-apple-system"
        "BlinkMacSystemFont"
        "Segoe UI"
        "Roboto"
        "Helvetica Neue"
        "Arial"
        "sans-serif"
      ];

      mono = [
        "JetBrainsMono Nerd Font"
        "Fira Code"
        "SF Mono"
        "Monaco"
        "Consolas"
        "Liberation Mono"
        "Courier New"
        "monospace"
      ];

      serif = [
        "Georgia"
        "Cambria"
        "Times New Roman"
        "Times"
        "serif"
      ];
    };

    # Font sizes (in pixels)
    fontSize = {
      xs = 12;
      sm = 14;
      base = 16; # Base size
      lg = 18;
      xl = 20;
      "2xl" = 24;
      "3xl" = 30;
      "4xl" = 36;
      "5xl" = 48;
      "6xl" = 60;
      "7xl" = 72;
      "8xl" = 96;
      "9xl" = 128;
    };

    # Font weights
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

    # Line heights (ratios)
    lineHeight = {
      none = 1;
      tight = 1.25;
      snug = 1.375;
      normal = 1.5;
      relaxed = 1.625;
      loose = 2;
    };

    # Letter spacing (em values)
    letterSpacing = {
      tighter = -0.05;
      tight = -0.025;
      normal = 0;
      wide = 0.025;
      wider = 0.05;
      widest = 0.1;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # MOTION SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  motion = {
    # Durations (in milliseconds) - snappy for terminal efficiency
    duration = {
      instant = 0;
      fast = 100;
      normal = 150;
      slow = 300;
      slower = 500;
    };

    # Easing functions
    easing = {
      linear = "linear";
      ease = "ease";
      easeIn = "ease-in";
      easeOut = "ease-out";
      easeInOut = "ease-in-out";

      # Custom curves
      smooth = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      snappy = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      bounce = "cubic-bezier(0.68, -0.55, 0.265, 1.55)";
      terminal = "cubic-bezier(0, 0, 0.2, 1)"; # Sharp, terminal-like
    };

    # Delays (in milliseconds)
    delay = {
      none = 0;
      short = 50;
      medium = 100;
      long = 300;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # EFFECTS SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  effects = {
    # Shadows (minimal for terminal aesthetic - pure black prefers no shadows)
    shadow = {
      none = "none";
      sm = "0 1px 2px 0 rgba(0, 0, 0, 0.3)";
      base = "0 1px 3px 0 rgba(0, 0, 0, 0.4), 0 1px 2px 0 rgba(0, 0, 0, 0.3)";
      md = "0 4px 6px -1px rgba(0, 0, 0, 0.4), 0 2px 4px -1px rgba(0, 0, 0, 0.3)";
      lg = "0 10px 15px -3px rgba(0, 0, 0, 0.4), 0 4px 6px -2px rgba(0, 0, 0, 0.3)";
      xl = "0 20px 25px -5px rgba(0, 0, 0, 0.4), 0 10px 10px -5px rgba(0, 0, 0, 0.3)";
      "2xl" = "0 25px 50px -12px rgba(0, 0, 0, 0.5)";
      inner = "inset 0 2px 4px 0 rgba(0, 0, 0, 0.3)";
      # Glowing shadows for terminal accents
      glow = "0 0 10px rgba(0, 255, 0, 0.3)";
      glowStrong = "0 0 20px rgba(0, 255, 0, 0.5)";
    };

    # Opacity levels
    opacity = {
      "0" = 0;
      "10" = 0.1;
      "20" = 0.2;
      "30" = 0.3;
      "40" = 0.4;
      "50" = 0.5;
      "60" = 0.6;
      "70" = 0.7;
      "80" = 0.8;
      "90" = 0.9;
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
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # INTERACTION SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  interaction = {
    # Focus ring settings
    focus = {
      outlineWidth = 2;
      outlineOffset = 2;
      outlineStyle = "solid";

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

    # Cursor styles
    cursor = {
      auto = "auto";
      default = "default";
      pointer = "pointer";
      wait = "wait";
      text = "text";
      move = "move";
      notAllowed = "not-allowed";
    };

    # State timing (snappy for terminal)
    states = {
      hoverDelay = 50;
      activeDelay = 0;
      focusDelay = 0;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # Z-INDEX SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

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
    content = 10;
    overlay = 100;
    modal = 1000;
    popover = 2000;
    tooltip = 3000;
    notification = 4000;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BREAKPOINTS
  # ═══════════════════════════════════════════════════════════════════════════

  breakpoints = {
    xs = 480;
    sm = 768;
    md = 1024;
    lg = 1280;
    xl = 1536;
    xxl = 1920;
  };
}
