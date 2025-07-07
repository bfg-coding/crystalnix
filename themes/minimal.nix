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
