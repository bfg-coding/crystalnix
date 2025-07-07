{ baseStylesheet, lib }:
baseStylesheet // {
  visual = baseStylesheet.visual // {
    colors = baseStylesheet.visual.colors // {
      primary = baseStylesheet.visual.colors.blue;
      secondary = baseStylesheet.visual.colors.slate;
      accent = baseStylesheet.visual.colors.blue."400";

      background = {
        primary = baseStylesheet.visual.colors.slate."900";
        secondary = baseStylesheet.visual.colors.slate."800";
        tertiary = baseStylesheet.visual.colors.slate."700";
      };

      text = {
        primary = baseStylesheet.visual.colors.slate."50";
        secondary = baseStylesheet.visual.colors.slate."300";
        tertiary = baseStylesheet.visual.colors.slate."400";
      };

      border = {
        primary = baseStylesheet.visual.colors.slate."600";
        secondary = baseStylesheet.visual.colors.slate."700";
        focus = baseStylesheet.visual.colors.blue."500";
      };

      shadow = {
        primary = "rgba(0, 0, 0, 0.9)";
        secondary = "rgba(0, 0, 0, 0.6)";
      };
    };
  };
}
