# Design System - Tokyo Night Theme
# themes/tokyonight.nix
#
# A vibrant dark theme inspired by Tokyo's neon-lit night skyline
# Based on the popular Tokyo Night color scheme
# Contains only raw values - will be processed into multiple formats

{ lib }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR SYSTEM - Tokyo Night Palette
  # ═══════════════════════════════════════════════════════════════════════════

  colors = {
    # ═══════════════════════════════════════════════════════════════════════════
    # TOKYO NIGHT CORE COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    # Primary brand color (Tokyo Night Purple)
    primary = {
      "50" = "#f3f0ff";
      "100" = "#ede9fe";
      "200" = "#ddd6fe";
      "300" = "#c4b5fd";
      "400" = "#a78bfa";
      "500" = "#bb9af7"; # Tokyo Night signature purple
      "600" = "#9d7df0";
      "700" = "#7c3aed";
      "800" = "#6d28d9";
      "900" = "#5b21b6";
      "950" = "#4c1d95";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # TOKYO NIGHT SIGNATURE COLORS
    # ═══════════════════════════════════════════════════════════════════════════

    # Tokyo Night Blue (secondary brand)
    tokyo = {
      blue = "#7aa2f7"; # Bright blue
      cyan = "#7dcfff"; # Cyan accent
      purple = "#bb9af7"; # Main purple
      magenta = "#c0caf5"; # Light purple/magenta
      red = "#f7768e"; # Coral red
      orange = "#ff9e64"; # Warm orange
      yellow = "#e0af68"; # Golden yellow
      green = "#9ece6a"; # Bright green
      teal = "#73daca"; # Teal accent
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # BACKGROUNDS (Tokyo Night's layered dark backgrounds)
    # ═══════════════════════════════════════════════════════════════════════════

    # Tokyo Night background hierarchy
    bg = {
      primary = "#1a1b26"; # Main background (darkest)
      secondary = "#24283b"; # Panel/card background
      tertiary = "#414868"; # Elevated surfaces
      quaternary = "#565f89"; # Highest surfaces
      highlight = "#292e42"; # Subtle highlight
      float = "#16161e"; # Floating windows (even darker)
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # TEXT COLORS (Tokyo Night text hierarchy)
    # ═══════════════════════════════════════════════════════════════════════════

    fg = {
      primary = "#c0caf5"; # Main text (light blue-white)
      secondary = "#a9b1d6"; # Secondary text
      tertiary = "#9aa5ce"; # Muted text
      quaternary = "#737aa2"; # Disabled text
      dark = "#565f89"; # Very muted text
      comment = "#565f89"; # Comments
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SEMANTIC COLORS (Tokyo Night style)
    # ═══════════════════════════════════════════════════════════════════════════

    # Success (Tokyo Night Green)
    success = {
      "50" = "#f0fdf4";
      "100" = "#dcfce7";
      "200" = "#bbf7d0";
      "300" = "#86efac";
      "400" = "#4ade80";
      "500" = "#9ece6a"; # Tokyo Night green
      "600" = "#16a34a";
      "700" = "#15803d";
      "800" = "#166534";
      "900" = "#14532d";
    };

    # Warning (Tokyo Night Orange)
    warning = {
      "50" = "#fff7ed";
      "100" = "#ffedd5";
      "200" = "#fed7aa";
      "300" = "#fdba74";
      "400" = "#fb923c";
      "500" = "#ff9e64"; # Tokyo Night orange
      "600" = "#ea580c";
      "700" = "#c2410c";
      "800" = "#9a3412";
      "900" = "#7c2d12";
    };

    # Error (Tokyo Night Red)
    error = {
      "50" = "#fef2f2";
      "100" = "#fee2e2";
      "200" = "#fecaca";
      "300" = "#fca5a5";
      "400" = "#f87171";
      "500" = "#f7768e"; # Tokyo Night coral red
      "600" = "#dc2626";
      "700" = "#b91c1c";
      "800" = "#991b1b";
      "900" = "#7f1d1d";
    };

    # Info (Tokyo Night Cyan)
    info = {
      "50" = "#ecfeff";
      "100" = "#cffafe";
      "200" = "#a5f3fc";
      "300" = "#67e8f9";
      "400" = "#22d3ee";
      "500" = "#7dcfff"; # Tokyo Night cyan
      "600" = "#0891b2";
      "700" = "#0e7490";
      "800" = "#155e75";
      "900" = "#164e63";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # UTILITY COLOR PALETTES
    # ═══════════════════════════════════════════════════════════════════════════

    # Tokyo Night's dark grays/blues
    slate = {
      "50" = "#f8fafc";
      "100" = "#f1f5f9";
      "200" = "#e2e8f0";
      "300" = "#cbd5e1";
      "400" = "#94a3b8";
      "500" = "#737aa2"; # Tokyo Night muted
      "600" = "#565f89"; # Tokyo Night dark
      "700" = "#414868"; # Tokyo Night darker
      "800" = "#24283b"; # Tokyo Night panel
      "900" = "#1a1b26"; # Tokyo Night bg
      "950" = "#16161e"; # Tokyo Night darkest
    };

    # Alternative palette (more blue-tinted)
    zinc = {
      "50" = "#fafafa";
      "100" = "#f4f4f5";
      "200" = "#e4e4e7";
      "300" = "#d4d4d8";
      "400" = "#a9b1d6"; # Tokyo Night light text
      "500" = "#9aa5ce"; # Tokyo Night medium text
      "600" = "#737aa2"; # Tokyo Night muted
      "700" = "#565f89"; # Tokyo Night dark
      "800" = "#414868"; # Tokyo Night darker
      "900" = "#24283b"; # Tokyo Night panel
      "950" = "#1a1b26"; # Tokyo Night bg
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # ACCENT COLORS (Tokyo Night rainbow)
    # ═══════════════════════════════════════════════════════════════════════════

    # Secondary accent (Tokyo Night Blue)
    secondary = {
      "50" = "#eff6ff";
      "100" = "#dbeafe";
      "200" = "#bfdbfe";
      "300" = "#93c5fd";
      "400" = "#60a5fa";
      "500" = "#7aa2f7"; # Tokyo Night blue
      "600" = "#2563eb";
      "700" = "#1d4ed8";
      "800" = "#1e40af";
      "900" = "#1e3a8a";
      "950" = "#172554";
    };

    # Accent color (Tokyo Night Teal)
    accent = {
      "50" = "#f0fdfa";
      "100" = "#ccfbf1";
      "200" = "#99f6e4";
      "300" = "#5eead4";
      "400" = "#2dd4bf";
      "500" = "#73daca"; # Tokyo Night teal
      "600" = "#0d9488";
      "700" = "#0f766e";
      "800" = "#115e59";
      "900" = "#134e4a";
      "950" = "#042f2e";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SURFACE COLORS (Tokyo Night elevation)
    # ═══════════════════════════════════════════════════════════════════════════

    surface = {
      "0" = "#1a1b26"; # Base level (main bg)
      "1" = "#24283b"; # Slightly elevated (panels)
      "2" = "#292e42"; # Cards, modals (highlight)
      "3" = "#414868"; # Dropdowns, tooltips (elevated)
      "4" = "#565f89"; # Highest elevation (borders)
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # UTILITY COLORS (Tokyo Night specific)
    # ═══════════════════════════════════════════════════════════════════════════

    utility = {
      # Border utilities (Tokyo Night borders)
      border = {
        subtle = "#292e42"; # Very subtle borders
        default = "#414868"; # Standard borders  
        emphasis = "#565f89"; # Emphasized borders
        strong = "#737aa2"; # Strong borders
        inactive = "#292e42"; # Inactive borders
        focus = "#bb9af7"; # Focus borders (purple)
      };

      # Text utilities (Tokyo Night text)
      text = {
        ghost = "#565f89"; # Very muted text
        muted = "#737aa2"; # Muted text
        subtle = "#9aa5ce"; # Subtle text
        default = "#c0caf5"; # Default text (main)
        emphasis = "#ffffff"; # Emphasized text (pure white)
        accent = "#bb9af7"; # Accent text (purple)
      };

      # Overlay utilities (for Tokyo Night backgrounds)
      overlay = {
        subtle = "#1a1b2608"; # 3% dark overlay
        light = "#1a1b2620"; # 12% dark overlay  
        medium = "#1a1b2640"; # 25% dark overlay
        heavy = "#1a1b2680"; # 50% dark overlay
      };

      # Selection colors
      selection = {
        bg = "#33467c"; # Selection background
        fg = "#c0caf5"; # Selection text
      };
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SEMANTIC ALIASES (Tokyo Night optimized)
    # ═══════════════════════════════════════════════════════════════════════════

    background = {
      primary = "#1a1b26"; # Main app background
      secondary = "#24283b"; # Card/panel background
      tertiary = "#292e42"; # Elevated surfaces
      quaternary = "#414868"; # Highest surfaces
      inverse = "#c0caf5"; # Light background (for contrast)
      float = "#16161e"; # Floating windows (darker)
    };

    text = {
      primary = "#c0caf5"; # Main text (Tokyo Night light)
      secondary = "#9aa5ce"; # Muted text
      tertiary = "#737aa2"; # Disabled text
      inverse = "#1a1b26"; # Dark text (on light backgrounds)
      accent = "#bb9af7"; # Link/accent text (purple)
      ghost = "#565f89"; # Very subtle text
      comment = "#565f89"; # Comments
    };

    border = {
      primary = "#414868"; # Default borders
      secondary = "#292e42"; # Subtle borders
      tertiary = "#24283b"; # Very subtle borders
      focus = "#bb9af7"; # Focus outlines (purple)
      error = "#f7768e"; # Error borders (coral)
      inactive = "#292e42"; # Inactive borders
      emphasis = "#565f89"; # Emphasized borders
      active = "#bb9af7"; # Active borders (purple)
    };

    # Terminal colors (for terminal emulators)
    terminal = {
      black = "#15161e";
      red = "#f7768e";
      green = "#9ece6a";
      yellow = "#e0af68";
      blue = "#7aa2f7";
      magenta = "#bb9af7";
      cyan = "#7dcfff";
      white = "#a9b1d6";
      brightBlack = "#414868";
      brightRed = "#f7768e";
      brightGreen = "#9ece6a";
      brightYellow = "#e0af68";
      brightBlue = "#7aa2f7";
      brightMagenta = "#bb9af7";
      brightCyan = "#7dcfff";
      brightWhite = "#c0caf5";
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
  # TYPOGRAPHY SYSTEM (identical to other themes)
  # ═══════════════════════════════════════════════════════════════════════════

  typography = {
    # Font families
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
        "JetBrains Mono"
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
  # MOTION SYSTEM (slightly enhanced for Tokyo Night)
  # ═══════════════════════════════════════════════════════════════════════════

  motion = {
    # Durations (in milliseconds) - slightly faster for Tokyo Night's snappy feel
    duration = {
      instant = 0;
      fast = 120; # Slightly faster than default
      normal = 200; # Slightly faster than default
      slow = 350; # Slightly faster than default
      slower = 600; # Slightly faster than default
    };

    # Easing functions
    easing = {
      linear = "linear";
      ease = "ease";
      easeIn = "ease-in";
      easeOut = "ease-out";
      easeInOut = "ease-in-out";

      # Custom curves for Tokyo Night's smooth feel
      smooth = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      snappy = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      bounce = "cubic-bezier(0.68, -0.55, 0.265, 1.55)";
      tokyo = "cubic-bezier(0.4, 0, 0.2, 1)"; # Material Design inspired
    };

    # Delays (in milliseconds)
    delay = {
      none = 0;
      short = 75; # Slightly faster
      medium = 150; # Slightly faster
      long = 400; # Slightly faster
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # EFFECTS SYSTEM (Tokyo Night optimized)
  # ═══════════════════════════════════════════════════════════════════════════

  effects = {
    # Shadows (more prominent for Tokyo Night's depth)
    shadow = {
      none = "none";
      sm = "0 1px 2px 0 rgba(26, 27, 38, 0.1)";
      base = "0 1px 3px 0 rgba(26, 27, 38, 0.2), 0 1px 2px 0 rgba(26, 27, 38, 0.12)";
      md = "0 4px 6px -1px rgba(26, 27, 38, 0.2), 0 2px 4px -1px rgba(26, 27, 38, 0.12)";
      lg = "0 10px 15px -3px rgba(26, 27, 38, 0.2), 0 4px 6px -2px rgba(26, 27, 38, 0.1)";
      xl = "0 20px 25px -5px rgba(26, 27, 38, 0.2), 0 10px 10px -5px rgba(26, 27, 38, 0.08)";
      "2xl" = "0 25px 50px -12px rgba(26, 27, 38, 0.3)";
      inner = "inset 0 2px 4px 0 rgba(26, 27, 38, 0.12)";
      # Glowing shadows for accents
      glow = "0 0 20px rgba(187, 154, 247, 0.3)";
      glowStrong = "0 0 30px rgba(187, 154, 247, 0.5)";
    };

    # Opacity levels (identical to other themes)
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

    # Blur effects (enhanced for Tokyo Night)
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
  # INTERACTION SYSTEM (identical to other themes)
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

    # State timing (slightly faster for Tokyo Night)
    states = {
      hoverDelay = 75;
      activeDelay = 0;
      focusDelay = 0;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # Z-INDEX SYSTEM (identical to other themes)
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
  # BREAKPOINTS (identical to other themes)
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
