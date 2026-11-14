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
    codexTmp=${lib.escapeShellArg "${config.home.homeDirectory}/.codex/.tmp"}

    # Home Manager activations have a minimal PATH. Codex shells out to Git
    # for remote marketplaces, so make the configured Git package explicit.
    export PATH=${lib.escapeShellArg (lib.makeBinPath [ config.programs.git.package ])}:$PATH

    # Codex records Git marketplace checkouts below .codex/.tmp, but a new
    # machine may have the registry state before this untracked directory.
    run mkdir -p "$codexTmp/marketplaces"

    marketplacesJson="$($codexBin plugin marketplace list --json)"
    revdiffRoot="$("$jqBin" -r '.marketplaces[] | select(.name == "revdiff") | .root' <<<"$marketplacesJson")"
    if [[ -n "$revdiffRoot" && ! -d "$revdiffRoot" ]]; then
      run "$codexBin" plugin marketplace remove revdiff
      revdiffRoot=
    fi
    if [[ -z "$revdiffRoot" ]]; then
      run "$codexBin" plugin marketplace add umputun/revdiff
    fi

    pluginsJson="$($codexBin plugin list --json)"
    if "$jqBin" -e '.installed[] | select(.pluginId == "revdiff-planning@revdiff")' \
      <<<"$pluginsJson" >/dev/null; then
      run "$codexBin" plugin remove revdiff-planning@revdiff
    fi
    for plugin in revdiff@revdiff; do
      pluginPath="$("$jqBin" -r --arg plugin "$plugin" '.installed[] | select(.pluginId == $plugin) | .source.path // empty' <<<"$pluginsJson")"
      if [[ -n "$pluginPath" && ! -d "$pluginPath" ]]; then
        run "$codexBin" plugin remove "$plugin"
        pluginPath=
      fi
      if [[ -z "$pluginPath" ]]; then
        run "$codexBin" plugin add "$plugin"
      fi
    done

    # These were previously copied directly; the plugins now own their skills.
    run rm -rf \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/skills/revdiff"} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/skills/revdiff-plan"}
  '';
}
