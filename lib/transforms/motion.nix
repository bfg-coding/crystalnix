# Design System - Motion Transform Functions
# lib/transforms/motion.nix
#
# Transforms raw motion/timing values into multiple format objects

{ lib, utils, defaults }:

rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # DURATION TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform duration into multiple time units
  # Input: 300 (milliseconds)
  # Output: { ms = "300ms"; s = "0.3s"; raw = 300; }
  duration = value:
    let
      # Validate input is a number
      isValid = builtins.isInt value || builtins.isFloat value;

      # Check duration constraints
      withinRange =
        if defaults.features.enableValidation
        then value >= defaults.constraints.duration.min &&
          value <= defaults.constraints.duration.max
        else true;

      # If validation enabled and value is invalid, throw error  
      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "${defaults.errors.invalidNumber}: ${toString value}"
          else if !withinRange then throw "${defaults.errors.outOfRange}: ${toString value} (duration should be ${toString defaults.constraints.duration.min}-${toString defaults.constraints.duration.max}ms)"
          else value
        else value;

    in
    {
      # Milliseconds format (most common for CSS animations)
      ms = utils.toMs validated;

      # Seconds format (alternative CSS format)
      s = utils.msToS validated;

      # Raw number (for calculations)
      raw = validated;

      # Semantic categories for debugging/selection
      category =
        if validated == 0 then "instant"
        else if validated <= 100 then "fast"
        else if validated <= 300 then "normal"
        else if validated <= 500 then "slow"
        else "slower";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        withinRange = withinRange;
        inSeconds = validated / 1000.0;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # EASING TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform easing function (mostly pass-through with validation)
  # Input: "ease-in-out" or cubic-bezier string
  # Output: { raw = "ease-in-out"; css = "ease-in-out"; }
  easing = value:
    let
      # Validate input is a string
      isValid = builtins.isString value;

      # Common easing functions for validation
      commonEasings = [
        "linear"
        "ease"
        "ease-in"
        "ease-out"
        "ease-in-out"
        "step-start"
        "step-end"
      ];

      # Check if it's a cubic-bezier function
      isCubicBezier = lib.hasPrefix "cubic-bezier(" value;

      # Check if it's a steps function
      isSteps = lib.hasPrefix "steps(" value;

      # Validate easing function
      isKnownEasing = builtins.elem value commonEasings || isCubicBezier || isSteps;

      validated =
        if defaults.features.enableValidation then
          if !isValid then throw "Easing function must be a string, got: ${builtins.typeOf value}"
          else if defaults.features.strictMode && !isKnownEasing then throw "Unknown easing function: ${value}"
          else value
        else value;

    in
    {
      # Raw string (most common usage)
      raw = validated;

      # CSS format (same as raw)
      css = validated;

      # Category for semantic understanding
      category =
        if builtins.elem validated [ "linear" ] then "linear"
        else if builtins.elem validated [ "ease" "ease-in-out" ] then "smooth"
        else if builtins.elem validated [ "ease-in" ] then "accelerate"
        else if builtins.elem validated [ "ease-out" ] then "decelerate"
        else if isCubicBezier then "custom-bezier"
        else if isSteps then "stepped"
        else "unknown";

      # Debug info
    } // lib.optionalAttrs defaults.features.includeDebugInfo {
      _debug = {
        input = value;
        validated = validated;
        isKnownEasing = isKnownEasing;
        isCubicBezier = isCubicBezier;
        isSteps = isSteps;
      };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # DELAY TRANSFORM
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform delay (same as duration)
  # Input: 100 (milliseconds)
  # Output: { ms = "100ms"; s = "0.1s"; raw = 100; }
  delay = duration; # Delays use same transform as durations

  # ═══════════════════════════════════════════════════════════════════════════
  # SPECIALIZED MOTION TRANSFORMS
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform for CSS transition shorthand
  # Input: { duration = 300; easing = "ease-out"; delay = 0; }
  # Output: { css = "300ms ease-out 0ms"; components = {...}; }
  transition = { duration ? 300, easing ? "ease", delay ? 0, property ? "all" }:
    let
      durationTransform = duration duration;
      easingTransform = easing easing;
      delayTransform = duration delay;
    in
    {
      # CSS shorthand format
      css = "${property} ${durationTransform.ms} ${easingTransform.css} ${delayTransform.ms}";

      # Individual components
      components = {
        property = property;
        duration = durationTransform;
        easing = easingTransform;
        delay = delayTransform;
      };

      # Raw object
      raw = { inherit duration easing delay property; };
    };

  # Transform for CSS animation
  # Input: { duration = 1000; easing = "ease-in-out"; delay = 500; iterations = 1; }
  animation = { duration ? 1000, easing ? "ease", delay ? 0, iterations ? 1, direction ? "normal", fillMode ? "both" }:
    let
      durationTransform = duration duration;
      easingTransform = easing easing;
      delayTransform = duration delay;
      iterationsStr = if iterations == null then "infinite" else toString iterations;
    in
    {
      # CSS animation shorthand (without name)
      css = "${durationTransform.ms} ${easingTransform.css} ${delayTransform.ms} ${iterationsStr} ${direction} ${fillMode}";

      # Individual components
      components = {
        duration = durationTransform;
        easing = easingTransform;
        delay = delayTransform;
        inherit iterations direction fillMode;
      };

      # Raw object
      raw = { inherit duration easing delay iterations direction fillMode; };
    };

  # ═══════════════════════════════════════════════════════════════════════════
  # BATCH MOTION PROCESSING
  # ═══════════════════════════════════════════════════════════════════════════

  # Transform motion object
  transformMotion = motionSet:
    lib.mapAttrs
      (name: value:
        if name == "duration" || name == "delay" then duration value
        else if name == "easing" then easing value
        else value  # Pass through unknown properties
      )
      motionSet;

  # ═══════════════════════════════════════════════════════════════════════════
  # PREDEFINED EASING CURVES
  # ═══════════════════════════════════════════════════════════════════════════

  # Common easing curves for convenience
  easingCurves = {
    # Basic CSS easings
    linear = easing "linear";
    ease = easing "ease";
    easeIn = easing "ease-in";
    easeOut = easing "ease-out";
    easeInOut = easing "ease-in-out";

    # Custom Material Design curves
    standard = easing (utils.cubicBezier 0.4 0.0 0.2 1);
    decelerate = easing (utils.cubicBezier 0.0 0.0 0.2 1);
    accelerate = easing (utils.cubicBezier 0.4 0.0 1 1);

    # Popular custom curves
    smooth = easing (utils.cubicBezier 0.25 0.46 0.45 0.94);
    bounce = easing (utils.cubicBezier 0.68 (-0.55) 0.265 1.55);
    snappy = easing (utils.cubicBezier 0.25 0.46 0.45 0.94);
  };

  # Common durations for convenience
  commonDurations = {
    instant = duration 0;
    fast = duration 150;
    normal = duration 250;
    slow = duration 400;
    slower = duration 700;
    slowest = duration 1000;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VALIDATION UTILITIES
  # ═══════════════════════════════════════════════════════════════════════════

  # Validate motion values
  validateDuration = value: (builtins.isInt value || builtins.isFloat value) && value >= 0;
  validateEasing = value: builtins.isString value;
}
