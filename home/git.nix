{...}: {

  programs.git = {
    enable = true;
    settings = {
      pull = { rebase = true; };
      user = {
        name = "Patrick Lange";
        email = "patrick.l.lange@gmail.com";
      };
    };
  };

}