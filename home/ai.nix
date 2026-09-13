{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    inputs.claude-code.packages.${pkgs.system}.default
    inputs.codex-cli-nix.packages.${pkgs.system}.default
    inputs.revdiff.packages.${pkgs.system}.default
    pkgs.jq
  ];

  # Codex may need to update skill-local state, so install real writable files
  # rather than Home Manager symlinks into the read-only Nix store.
  home.activation.installRevdiffCodexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codexSkillsDir=${lib.escapeShellArg "${config.home.homeDirectory}/.codex/skills"}

    for skill in revdiff revdiff-plan; do
      skillDir="$codexSkillsDir/$skill"
      run rm -rf "$skillDir"
      run mkdir -p "$skillDir"
      run cp -R "${inputs.revdiff}/plugins/codex/skills/$skill/." "$skillDir/"
      run chmod -R u+w "$skillDir"
    done
  '';
}
