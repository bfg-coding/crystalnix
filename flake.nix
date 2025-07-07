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
              _meta = {
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
              
                # Check if theme exists by trying to access the prebuilt package
                if ! nix eval .#packages.x86_64-linux.$theme._meta --json >/dev/null 2>&1; then
                  echo "❌ Theme '$theme' not found"
                  echo ""
                  echo "Available themes:"
                  ${lib.concatMapStringsSep "\n" (theme: "echo '  - ${theme}'") availableThemes}
                  exit 1
                fi
              
                # Load the theme and extract key info using prebuilt packages
                echo "📊 Theme Metadata:"
                nix eval .#packages.x86_64-linux.$theme._meta --json | ${pkgs.jq}/bin/jq -r 'to_entries[] | "  \(.key): \(.value)"'
              
                echo ""
                echo "🎨 Key Colors:"
                nix eval .#packages.x86_64-linux.$theme.visual.colors --json | ${pkgs.jq}/bin/jq -r '{
                  "primary-500": .primary."500",
                  "background-primary": .background.primary,
                  "text-primary": .text.primary,
                  "border-primary": .border.primary
                } | to_entries[] | "  \(.key): \(.value)"'
              
                echo ""
                echo "📏 Layout Values:"
                nix eval .#packages.x86_64-linux.$theme.layout --json | ${pkgs.jq}/bin/jq -r '{
                  "spacing-sm": .spacing.sm,
                  "spacing-md": .spacing.md,
                  "spacing-lg": .spacing.lg,
                  "border-radius-md": .borders.radius.md
                } | to_entries[] | "  \(.key): \(.value)"'
              
                echo ""
                echo "⚡ Motion Settings:"
                nix eval .#packages.x86_64-linux.$theme.motion --json | ${pkgs.jq}/bin/jq -r '{
                  "duration-fast": .duration.fast,
                  "duration-normal": .duration.normal,
                  "easing-smooth": .easing.smooth
                } | to_entries[] | "  \(.key): \(.value)"'
              
                echo ""
                echo "💡 Usage example:"
                echo "  stylesheet.visual.colors.primary.\"500\"  # $(nix eval .#packages.x86_64-linux.$theme.visual.colors.primary.\"500\" --raw)"
                echo "  stylesheet.layout.spacing.md            # $(nix eval .#packages.x86_64-linux.$theme.layout.spacing.md)"
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
              
                # Get theme data using prebuilt packages
                t1_primary=$(nix eval .#packages.x86_64-linux.$theme1.visual.colors.primary.\"500\" --raw)
                t1_bg=$(nix eval .#packages.x86_64-linux.$theme1.visual.colors.background.primary --raw)
                t1_spacing=$(nix eval .#packages.x86_64-linux.$theme1.layout.spacing.md)
              
                t2_primary=$(nix eval .#packages.x86_64-linux.$theme2.visual.colors.primary.\"500\" --raw)
                t2_bg=$(nix eval .#packages.x86_64-linux.$theme2.visual.colors.background.primary --raw)
                t2_spacing=$(nix eval .#packages.x86_64-linux.$theme2.layout.spacing.md)
              
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
                dark_bg=$(nix eval .#lib.mkStylesheet --arg theme '"dark"' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')
                light_bg=$(nix eval .#lib.mkStylesheet --arg theme '"light"' --json | ${pkgs.jq}/bin/jq -r '.visual.colors.background.primary')
              
                echo "  Dark background: $dark_bg"
                echo "  Light background: $light_bg"
              
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
            _meta = { currentTheme = theme; hasOverrides = overrides != { }; };
          };
      };
    };
}
