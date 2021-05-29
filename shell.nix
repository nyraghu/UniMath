### Specification for nix-shell

let
  nixpkgsPath =
    builtins.fetchTarball {
      ## github:NixOS/nixpkgs, nixpkgs-unstable branch, 2021-05-12
      url = "https://github.com/NixOS/nixpkgs/archive/4d8dd0afd2d5a35acb5e34c5c7b1674b74173d87.tar.gz";
      sha256 = "1d7z53vzq9jjy0dmq8w952dlxvajxrbmbn9926yhfp610p93ns84";
    };
  ixnayPath =
    builtins.fetchTarball {
      url = "https://github.com/nyraghu/ixnay/archive/f1dfe26543b0da17c3940e096c9953ac8895de1e.tar.gz";
      sha256 = "02ah73mdq71clbg8jjg6y68nrlswbpcsninj39yjfyl197jp6dzl";
    };
  nixpkgs = import nixpkgsPath {};
  ixnay = import ixnayPath { inherit nixpkgs; };
  coq = nixpkgs.coq;
  ## This is the value of `propagatedBuildInputs' in the Nix setup of
  ## the Coq project.
  ## <https://github.com/coq/coq/blob/ac9a31046f82a4a489452b82c56a9d8cb7efc77c/default.nix#L74>
  ocamlPackages = with coq.ocamlPackages; [ findlib ocaml zarith ];
  coqdoc-overlay = ixnay.coqdoc-overlay;
  coqPackages = [ coq coqdoc-overlay ] ++ ocamlPackages;
  generalPackages = [];
  packages = coqPackages ++ generalPackages;
  manDirs = builtins.map (x: x + "/share/man") packages;
  MANPATH = (builtins.concatStringsSep ":" manDirs)
            + ":" + (builtins.getEnv "MANPATH");
in nixpkgs.mkShell {
  buildInputs = packages;
  inherit MANPATH coq;
  ## Replace the hyphen because it is not allowed in the name of a
  ## shell variable.
  coqdoc_overlay = coqdoc-overlay;
}

### End of file
