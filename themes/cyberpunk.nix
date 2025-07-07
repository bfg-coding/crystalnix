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
