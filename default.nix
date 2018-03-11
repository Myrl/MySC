{ pkgs ? import <nixpkgs> {system = "i686-linux"; config = (import ./config.nix) compiler;}
, compiler ? "ghc802", runCompiler ? true
}:
let
in pkgs.haskellPackages.mkDerivation {
  pname = "heroku-comment-server";
  version = "0.1.0.0";
  src = ./.;

  executableHaskellDepends = with pkgs.haskellPackages; [
    Spock transformers persistent persistent-template persistent-postgresql
    monad-logger text pwstore-fast bytestring resourcet hvect time
    blaze-html clay aeson
  ];

  buildDepends = [];

#  buildTools = pkgs.stdenv.lib.optional runCompiler [pkgs.closurecompiler];
#  
#  postInstall =
#    (if runCompiler
#    then "closure-compiler -O ADVANCED --js $out/bin/CellGame.jsexe/all.js --js_output_file $out/all.min.js"
#    else "cp $out/bin/CellGame.jsexe/all.js $out/all.min.js") + "\n" +
#    ''
#      cp ${./static}/* -r $out
#      echo "<html> <head> <script src=\"all.min.js\"></script> </head> </html>" > $out/index.html
#      rm -r $out/bin
#    '';

  license = pkgs.stdenv.lib.licenses.gpl3;

  isExecutable = true;
}
