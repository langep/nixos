{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    inputs.claude-code.packages.${pkgs.system}.default
    inputs.codex-cli-nix.packages.${pkgs.system}.default
  ];
}
