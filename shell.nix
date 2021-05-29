### Specification for nix-shell

let
  nixpkgsPath =
    builtins.fetchTarball {
      ## github:NixOS/nixpkgs, nixpkgs-unstable branch, 2021-05-12
      url = "https://github.com/NixOS/nixpkgs/archive/4d8dd0afd2d5a35acb5e34c5c7b1674b74173d87.tar.gz";
      sha256 = "1d7z53vzq9jjy0dmq8w952dlxvajxrbmbn9926yhfp610p93ns84";
    };
  nixpkgs = import nixpkgsPath {};
  coq = nixpkgs.coq;
  ## This is the value of `propagatedBuildInputs' in the Nix setup of
  ## the Coq project.
  ## <https://github.com/coq/coq/blob/ac9a31046f82a4a489452b82c56a9d8cb7efc77c/default.nix#L74>
  ocamlPackages = with coq.ocamlPackages; [ findlib ocaml zarith ];
  coqPackages = [ coq ] ++ ocamlPackages;
  generalPackages = [];
  packages = coqPackages ++ generalPackages;
  manDirs = builtins.map (x: x + "/share/man") packages;
  MANPATH = (builtins.concatStringsSep ":" manDirs)
            + ":" + (builtins.getEnv "MANPATH");
in nixpkgs.mkShell {
  buildInputs = packages;
  inherit MANPATH coq;
}

### End of file
