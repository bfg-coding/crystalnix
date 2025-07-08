# Design System - Theme Processor
# lib/processor.nix
#
# Core function that transforms raw themes into full stylesheets
# This recursively walks the theme structure and applies transforms

{ lib, utils, schema, transforms, defaults }:

let
  # Get transform function from registry, with fallback to raw
  getTransform = transformType:
    transforms.getTransform transformType;

  # Check if a path should be ignored during processing
  shouldIgnore = path:
    let
      ignoreList = schema._ignore or [ ];
    in
    builtins.elem path ignoreList;

  # Get transform type for a given path in the schema
  # Returns the transform type string, or "_default" if not found
  getTransformType = path: schemaSection:
    let
      # Handle string transform type (leaf node)
      handleString = transformType: transformType;

      # Handle nested schema section
      handleNested = nestedSchema:
        if path == [ ] then
          let defaultVal = schema._default or "raw"; in defaultVal
        else if builtins.length path == 1 then
          let
            key = builtins.head path;
            defaultVal = schema._default or "raw";
          in
            nestedSchema.${key} or defaultVal
        else
          let
            key = builtins.head path;
            restPath = builtins.tail path;
            nextSection = nestedSchema.${key} or null;
            defaultVal = schema._default or "raw";
          in
          if nextSection == null then defaultVal
          else getTransformType restPath nextSection;
    in
    if builtins.isString schemaSection then handleString schemaSection
    else if builtins.isAttrs schemaSection then handleNested schemaSection
    else
      let defaultVal = schema._default or "raw"; in defaultVal;

  # Convert a path list to a dot-separated string for debugging
  pathToString = path: lib.concatStringsSep "." path;

  # Check if a value is a "leaf" value that should be transformed
  # (not an attribute set, or an attribute set that looks like it's already transformed)
  isLeafValue = value:
    !builtins.isAttrs value ||
    # If it's an attrs but has transform output properties, it's already processed
    (builtins.isAttrs value && (value ? raw || value ? hex || value ? px));

  # Process a single value with its transform
  processValue = path: value: transformType:
    let
      transform = getTransform transformType;
      pathStr = pathToString path;
    in
    if defaults.features.enableValidation && transformType == null then
      throw "No transform found for path: ${pathStr}"
    else
      let
        result = builtins.tryEval (transform value);
      in
      if result.success then
        result.value
      else if defaults.features.strictMode then
        throw "Transform error at ${pathStr}: evaluation failed"
      else
        utils.debugWith "Transform error at ${pathStr}, using raw value" value;

  # Main recursive processor function
  processThemeRecursive = path: value: schemaSection:
    let
      currentPath = pathToString path;

      # Check if this path should be ignored
      ignored = shouldIgnore (if path == [ ] then "" else builtins.head path);

      # Determine what to do based on value type
      processResult =
        if ignored then value
        else if isLeafValue value then
        # This is a leaf value - apply transform
          let transformType = getTransformType path schemaSection;
          in processValue path value transformType
        else if builtins.isAttrs value then
        # This is a nested object - recurse into it
          lib.mapAttrs
            (key: subValue:
              let newPath = path ++ [ key ];
              in processThemeRecursive newPath subValue schemaSection
            )
            value
        else
        # Other types (lists, etc.) - apply transform or pass through
          let transformType = getTransformType path schemaSection;
          in if transformType == "raw" then value
          else processValue path value transformType;
    in
    # Add debug info if enabled
    if defaults.features.includeDebugInfo && !ignored then
      processResult // {
        _debug = {
          path = currentPath;
          transformType = getTransformType path schemaSection;
          wasLeaf = isLeafValue value;
          originalValue = value;
        };
      }
    else processResult;

  # Validate theme structure before processing
  validateTheme = theme:
    let
      isValidStructure = builtins.isAttrs theme;
      hasContent = builtins.length (builtins.attrNames theme) > 0;
    in
    if !isValidStructure then
      throw "${defaults.errors.invalidThemeStructure}: theme must be an attribute set"
    else if !hasContent then
      throw "${defaults.errors.invalidThemeStructure}: theme cannot be empty"
    else theme;

  # Add metadata to processed theme
  addMetadata = processedTheme: originalTheme:
    processedTheme // {
      _meta = {
        designSystemVersion = "2.0.0";
        processedAt = "build-time"; # Would be timestamp in real system
        originalThemeKeys = builtins.attrNames originalTheme;
        processedKeys = builtins.attrNames processedTheme;
        transformsApplied = true;

        # Feature flags used during processing
        featuresUsed = defaults.features;

        # Statistics
        stats = {
          originalKeyCount = builtins.length (builtins.attrNames originalTheme);
          processedKeyCount = builtins.length (builtins.attrNames processedTheme);
        };
      };
    };

in

# Main export - the processTheme function
rawTheme:
let
  # Validate input theme
  validatedTheme =
    if defaults.features.enableValidation
    then validateTheme rawTheme
    else rawTheme;

  # Process the theme recursively starting from root
  processedTheme = processThemeRecursive [ ] validatedTheme schema;

  # Add metadata
  finalTheme =
    if defaults.features.includeDebugInfo
    then addMetadata processedTheme validatedTheme
    else processedTheme;

  # Performance warning for large themes
  _ =
    if defaults.performance.warnOnLargeThemes then
      let keyCount = builtins.length (builtins.attrNames validatedTheme);
      in if keyCount > defaults.performance.largeThemeThreshold
      then utils.debugWith "Warning: Large theme detected" keyCount
      else null
    else null;

in
finalTheme
