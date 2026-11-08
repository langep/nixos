{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  codex = inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    codex
    inputs.revdiff.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.jq
  ];

  home.activation.installRevdiffCodexPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codexBin=${lib.escapeShellArg (lib.getExe codex)}
    jqBin=${lib.escapeShellArg (lib.getExe pkgs.jq)}

    marketplacesJson="$($codexBin plugin marketplace list --json)"
    if ! "$jqBin" -e '.marketplaces[] | select(.name == "revdiff")' <<<"$marketplacesJson" >/dev/null; then
      run "$codexBin" plugin marketplace add umputun/revdiff
    fi

    pluginsJson="$($codexBin plugin list --json)"
    for plugin in revdiff@revdiff revdiff-planning@revdiff; do
      if ! "$jqBin" -e --arg plugin "$plugin" '.installed[] | select(.pluginId == $plugin)' <<<"$pluginsJson" >/dev/null; then
        run "$codexBin" plugin add "$plugin"
      fi
    done

    # These were previously copied directly; the plugins now own their skills.
    run rm -rf \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/skills/revdiff"} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/skills/revdiff-plan"}
  '';
}
