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
        (i: _: {
          name = toString i;
          value = base * (lib.pow multiplier i);
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
