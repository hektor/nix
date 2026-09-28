{
  ".." = "cd ..";

  ls = "ls --color=auto";
  l = "ls -1p";
  ll = "ls -lhp";
  lt = "ls -lhtp";
  la = "ls -lhap";
  lta = "ls -lhatp";
  ldir = "ls -dp"; # list directories
  grep = "grep --color=auto";

  rm = "rm -I --preserve-root";
  mv = "mv -iv";
  cp = "cp -iv";
  ln = "ln -i";
  mkdir = "mkdir -pv";
  chown = "chown --preserve-root";
  chmod = "chmod --preserve-root";
  chgrp = "chgrp --preserve-root";

  ip = "ip --color";
  ipa = "ip -brief address";
  ipl = "ip -brief link";
  ipr = "ip route";
  df = "df -kTh";
  fzfpac = "pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S";
  path = ''echo -e ''${PATH//:/\\n}''; # Pretty print path variables

  # Programs
  h = "history";
  o = "xdg-open";
  v = "nvim";
  vf = "fzf --bind 'enter:become(nvim {})'";
  g = "git";
  k = "kubectl";
  t = "task";
  tsh = "tasksh";
  z = "zathura --fork";
  f = "fzf";
  fm = "pcmanfm &>/dev/null &";
  mm = "micromamba";

  # Languages
  r5 = "plt-r5rs --no-prim";
  hs = "ghci";
  pl = "swipl";
  py = "python";
  r = "R";
}
