{ baseStylesheet, lib }:
baseStylesheet // {
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = baseStylesheet.visual.colors.blue;
      secondary = baseStylesheet.visual.colors.slate;
      accent = baseStylesheet.visual.colors.blue."600";

      background = {
        primary = baseStylesheet.visual.colors.white;
        secondary = baseStylesheet.visual.colors.slate."50";
        tertiary = baseStylesheet.visual.colors.slate."100";
      };

      text = {
        primary = baseStylesheet.visual.colors.slate."900";
        secondary = baseStylesheet.visual.colors.slate."700";
        tertiary = baseStylesheet.visual.colors.slate."500";
      };

      border = {
        primary = baseStylesheet.visual.colors.slate."300";
        secondary = baseStylesheet.visual.colors.slate."200";
        focus = baseStylesheet.visual.colors.blue."500";
      };

      shadow = {
        primary = "rgba(0, 0, 0, 0.15)";
        secondary = "rgba(0, 0, 0, 0.1)";
      };
    };
  };
}
