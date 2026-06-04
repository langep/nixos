{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    mouse = true;
    focusEvents = true;
    baseIndex = 1;
    historyLimit = 100000;

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

    extraConfig =
      let
        c = config.lib.stylix.colors.withHashtag;
        leftCap = "";
        rightCap = "";
        leftArrow = "";
        rightArrow = "";
      in
      ''
        set -ga terminal-overrides ",foot:Tc"
        set -s set-clipboard on
        set -g @continuum-restore 'on'

        # Pane/Window numbering
        set -g renumber-windows on
        setw -g pane-base-index 1

        # Open new window/pane in current directory
        bind c new-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"

        # Status bar
        # set -g status-position top
        set -g status-style "bg=${c.base01}"
        set -g status-justify absolute-centre
        set -g status-left "#[fg=${c.base01},bg=${c.base0D}] #S #[fg=${c.base0D},bg=default]${rightArrow} "
        set -g window-status-format "#[fg=${c.base03},bg=default]${leftCap}#[fg=${c.base05},bg=${c.base03}] #I #W #[fg=${c.base03},bg=default]${rightCap}"
        set -g window-status-current-format "#[fg=${c.base0D},bg=default]${leftCap}#[fg=${c.base00},bg=${c.base0D}] #I #W #[fg=${c.base0D},bg=default]${rightCap}"
        set -g status-right ""
        set -g status-left-length 100
        set -g status-right-length 100
      '';
  };
}
