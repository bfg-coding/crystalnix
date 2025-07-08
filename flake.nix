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

          # Import our design system library
          designSystem = import ./lib { inherit lib; };

          # Auto-discover available themes
          themesDir = ./themes;
          availableThemeFiles = builtins.filter
            (name: lib.hasSuffix ".nix" name && name != "default.nix")
            (builtins.attrNames (builtins.readDir themesDir));
          availableThemes = map (name: lib.removeSuffix ".nix" name) availableThemeFiles;

          # Main stylesheet function - now using processTheme
          mkStylesheet = { theme ? "dark", overrides ? { } }:
            let
              # Validate theme exists
              themeFile = themesDir + "/${theme}.nix";
              themeExists = builtins.pathExists themeFile;

              # Load the selected raw theme
              rawTheme =
                if themeExists
                then import themeFile { inherit lib; }
                else throw "Theme '${theme}' not found. Available themes: ${lib.concatStringsSep ", " availableThemes}";

              # Apply overrides to raw theme before processing
              rawThemeWithOverrides = lib.recursiveUpdate rawTheme overrides;

              # Process the raw theme into full stylesheet
              finalStylesheet = designSystem.processTheme rawThemeWithOverrides;
            in
            finalStylesheet // {
              # Expose metadata for tooling/discovery
              _meta = {
                inherit availableThemes;
                currentTheme = theme;
                hasOverrides = overrides != { };
                # Add info about the design system
                designSystemVersion = "2.0.0";
                transformsApplied = true;
              };
            };
        in
        {
          # Main library functions
          lib = {
            inherit mkStylesheet;
            listThemes = availableThemes;

            # Also expose the design system for advanced usage
            inherit (designSystem) processTheme themes;
            designSystem = designSystem;
          };

          # Pre-built themes for easy access
          packages = {
            default = mkStylesheet { };
            dark = mkStylesheet { theme = "dark"; };
            light = mkStylesheet { theme = "light"; };
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
              echo "  nix run .#formats     # Test format outputs"
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
              
                # Check if theme exists by trying to evaluate it
                if ! nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json >/dev/null 2>&1; then
                  echo "❌ Theme '$theme' not found"
                  echo ""
                  echo "Available themes:"
                  ${lib.concatMapStringsSep "\n" (theme: "echo '  - ${theme}'") availableThemes}
                  exit 1
                fi
              
                # Load the theme and extract key info
                echo "📊 Theme Metadata:"
                nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '._meta | to_entries[] | "  \(.key): \(.value)"'
              
                echo ""
                echo "🎨 Key Colors (multiple formats):"
                echo "  Primary (hex):  $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')"
                echo "  Primary (conf): $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".conf')"
                echo "  Background:     $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.background.primary.hex')"
              
                echo ""
                echo "📏 Layout Values:"
                echo "  Spacing md (px):  $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.px')"
                echo "  Spacing md (rem): $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.rem')"
                echo "  Spacing md (raw): $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.raw')"
              
                echo ""
                echo "⚡ Motion Settings:"
                echo "  Duration fast: $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.motion.duration.fast.ms')"
                echo "  Easing smooth: $(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.motion.easing.smooth.raw')"
              
                echo ""
                echo "💡 Usage examples:"
                echo "  # Hyprland config"
                echo "  stylesheet.colors.primary.\"500\".conf"
                echo "  # CSS"
                echo "  stylesheet.colors.primary.\"500\".hex"
                echo "  stylesheet.spacing.md.rem"
              '');
            };

            # Test format outputs
            formats = {
              type = "app";
              program = toString (pkgs.writeShellScript "crystalnix-formats" ''
                theme=''${1:-dark}
                
                echo "🔮 CrystalNix Format Testing: $theme theme"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                
                echo "🎨 Color Formats:"
                primary_hex=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')
                primary_conf=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".conf')
                echo "  .hex:  $primary_hex"
                echo "  .conf: $primary_conf"
                
                echo ""
                echo "📏 Spacing Formats:"
                spacing_px=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.px') 
                spacing_rem=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.rem')
                spacing_raw=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.raw')
                echo "  .px:  $spacing_px"
                echo "  .rem: $spacing_rem" 
                echo "  .raw: $spacing_raw"
                
                echo ""
                echo "⏱️  Duration Formats:"
                duration_ms=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.motion.duration.fast.ms')
                duration_s=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.motion.duration.fast.s')
                duration_raw=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme\"; }" --json | ${pkgs.jq}/bin/jq -r '.motion.duration.fast.raw')
                echo "  .ms:  $duration_ms"
                echo "  .s:   $duration_s"
                echo "  .raw: $duration_raw"
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
              
                # Get theme data using the lib
                t1_primary=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme1\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')
                t1_bg=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme1\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.background.primary.hex')
                t1_spacing=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme1\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.px')
              
                t2_primary=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme2\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')
                t2_bg=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme2\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.background.primary.hex')
                t2_spacing=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"$theme2\"; }" --json | ${pkgs.jq}/bin/jq -r '.spacing.md.px')
              
                echo "🎨 Primary Colors:"
                echo "  $theme1: $t1_primary"
                echo "  $theme2: $t2_primary"
              
                echo ""
                echo "🏠 Background Colors:"
                echo "  $theme1: $t1_bg"
                echo "  $theme2: $t2_bg"
              
                echo ""
                echo "📏 Spacing (md):"
                echo "  $theme1: $t1_spacing"
                echo "  $theme2: $t2_spacing"
              
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
                  if nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"${theme}\"; }" --json >/dev/null 2>&1; then
                    echo "✅"
                  else
                    echo "❌"
                    ((errors++))
                  fi
                '') availableThemes}
              
                # Test 2: Check format transforms work
                echo ""
                echo "📋 Test 2: Format Transforms"
                echo -n "  Testing color formats... "
                hex_format=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"dark\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex // empty')
                conf_format=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"dark\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".conf // empty')
                
                if [ -n "$hex_format" ] && [ -n "$conf_format" ] && [ "$hex_format" != "$conf_format" ]; then
                  echo "✅"
                else
                  echo "❌"
                  ((errors++))
                fi
              
                # Test 3: Check overrides work
                echo ""
                echo "📋 Test 3: Override Functionality"
                original=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"dark\"; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')
                override=$(nix eval .#lib --apply "lib: lib.mkStylesheet { theme = \"dark\"; overrides = { colors.primary.\"500\" = \"#ff0000\"; }; }" --json | ${pkgs.jq}/bin/jq -r '.colors.primary."500".hex')
              
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
                  echo "Try: nix run .#formats dark"
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
            designSystem = import ./lib { inherit lib; };
            rawTheme = import (./themes + "/${theme}.nix") { inherit lib; };
            rawThemeWithOverrides = lib.recursiveUpdate rawTheme overrides;
            finalStylesheet = designSystem.processTheme rawThemeWithOverrides;
          in
          finalStylesheet // {
            _meta = {
              currentTheme = theme;
              hasOverrides = overrides != { };
              designSystemVersion = "2.0.0";
            };
          };

        # Also expose the design system components
        processTheme = (import ./lib { inherit (nixpkgs) lib; }).processTheme;
      };
    };
}
