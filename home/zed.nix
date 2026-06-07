{ ... }:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "zig"
    ];

    userSettings = {
      helix_mode = true;
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
    };

  };
}
