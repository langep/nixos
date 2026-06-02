{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    # Replace 'cd' command
    options = [
      "--cmd cd"
    ];
  };
}
