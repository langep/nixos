{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    mouse = true;
    focusEvents = true;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key Space
          set -g @thumbs-command 'echo -n {} | wl-copy'
        '';
      }
      resurrect
      continuum
    ];

    extraConfig = ''
      set -ga terminal-overrides ",foot:Tc"
      set -s set-clipboard on
      set -g @continuum-restore 'on'
    '';
  };
}
