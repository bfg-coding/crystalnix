# Design System - Dark Theme
# lib/themes/dark.nix
#
# A modern dark theme optimized for terminals, code editors, and low-light use
# Contains only raw values - will be processed into multiple formats

{ lib }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # COLOR SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  colors = {
    # ─────────────────────────────────────────────────────────────────────────
    # NEUTRAL COLORS (grays for backgrounds, text, borders)
    # ─────────────────────────────────────────────────────────────────────────

    neutral = {
      "50" = "#fafafa"; # Lightest - for light mode compatibility
      "100" = "#f4f4f5";
      "200" = "#e4e4e7";
      "300" = "#d4d4d8";
      "400" = "#a1a1aa"; # Mid-tone
      "500" = "#71717a";
      "600" = "#52525b";
      "700" = "#3f3f46"; # Dark surfaces
      "800" = "#27272a"; # Card backgrounds
      "900" = "#18181b"; # Primary background
      "950" = "#09090b"; # Deepest background
    };

    # ─────────────────────────────────────────────────────────────────────────
    # BRAND COLORS (primary interface colors)
    # ─────────────────────────────────────────────────────────────────────────

    primary = {
      "50" = "#eff6ff";
      "100" = "#dbeafe";
      "200" = "#bfdbfe";
      "300" = "#93c5fd";
      "400" = "#60a5fa";
      "500" = "#3b82f6"; # Main brand blue
      "600" = "#2563eb";
      "700" = "#1d4ed8";
      "800" = "#1e40af";
      "900" = "#1e3a8a";
      "950" = "#172554";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SEMANTIC COLORS (status, feedback)
    # ─────────────────────────────────────────────────────────────────────────

    success = {
      "50" = "#f0fdf4";
      "100" = "#dcfce7";
      "200" = "#bbf7d0";
      "300" = "#86efac";
      "400" = "#4ade80";
      "500" = "#22c55e"; # Success green
      "600" = "#16a34a";
      "700" = "#15803d";
      "800" = "#166534";
      "900" = "#14532d";
    };

    warning = {
      "50" = "#fffbeb";
      "100" = "#fef3c7";
      "200" = "#fde68a";
      "300" = "#fcd34d";
      "400" = "#fbbf24";
      "500" = "#f59e0b"; # Warning orange
      "600" = "#d97706";
      "700" = "#b45309";
      "800" = "#92400e";
      "900" = "#78350f";
    };

    error = {
      "50" = "#fef2f2";
      "100" = "#fee2e2";
      "200" = "#fecaca";
      "300" = "#fca5a5";
      "400" = "#f87171";
      "500" = "#ef4444"; # Error red
      "600" = "#dc2626";
      "700" = "#b91c1c";
      "800" = "#991b1b";
      "900" = "#7f1d1d";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SEMANTIC ALIASES (for easy theme switching)
    # ─────────────────────────────────────────────────────────────────────────

    background = {
      primary = "#09090b"; # Main app background
      secondary = "#18181b"; # Card/panel background
      tertiary = "#27272a"; # Elevated surfaces
      inverse = "#fafafa"; # Light background (for contrast)
    };

    text = {
      primary = "#fafafa"; # Main text
      secondary = "#a1a1aa"; # Muted text
      tertiary = "#71717a"; # Disabled text
      inverse = "#18181b"; # Dark text (on light backgrounds)
      accent = "#3b82f6"; # Link/accent text
    };

    border = {
      primary = "#3f3f46"; # Default borders
      secondary = "#27272a"; # Subtle borders
      focus = "#3b82f6"; # Focus outlines
      error = "#ef4444"; # Error borders
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SPACING SYSTEM
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
  # BORDER SYSTEM
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
  # MOTION SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  motion = {
    # Durations (in milliseconds)
    duration = {
      instant = 0;
      fast = 150;
      normal = 250;
      slow = 400;
      slower = 700;
    };

    # Easing functions
    easing = {
      linear = "linear";
      ease = "ease";
      easeIn = "ease-in";
      easeOut = "ease-out";
      easeInOut = "ease-in-out";

      # Custom curves for smooth interactions
      smooth = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      snappy = "cubic-bezier(0.25, 0.46, 0.45, 0.94)";
      bounce = "cubic-bezier(0.68, -0.55, 0.265, 1.55)";
    };

    # Delays (in milliseconds)
    delay = {
      none = 0;
      short = 100;
      medium = 200;
      long = 500;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # EFFECTS SYSTEM
  # ═══════════════════════════════════════════════════════════════════════════

  effects = {
    # Shadows (CSS box-shadow values)
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

    # State timing
    states = {
      hoverDelay = 100;
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
  # BREAKPOINTS (for responsive design)
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
