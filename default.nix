(import
(
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in
  fetchTarball {
    url = "https://github.com/python-poetry/poetry/releases/download/${lock.nodes.poetry.locked.rev}/poetry-${lock.nodes.poetry.locked.rev}.tar.gz";
    sha256 = lock.nodes.poetry.locked.narHash;
  }
  )
  {
    src = ./.;
  }).defaultNix
