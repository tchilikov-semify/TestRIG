  { pkgs ? import <nixpkgs> {} }:
    pkgs.mkShell {
      buildInputs = with pkgs; [
        # Core build tools
        gnumake
        gcc
        git

        # Haskell toolchain (for QCVEngine)
        ghc
        cabal-install

        # Verilator (for CVA6 simulation)
        autoconf
        automake
        flex
        bison

        # Spike
        dtc
        cmake
        yaml-cpp
        help2man

        # Python for test scripts
        python3
        python3Packages.pip

        # RISC-V toolchain
        pkgs.pkgsCross.riscv64.buildPackages.gcc

        # Sail dependencies (OCaml-based)
        opam
        ocaml
        z3

        # System dependencies that opam needs
        findutils
        gmp
        gmpxx
        pkg-config
        zlib

        # Additional utilities
        which
        perl
      ];
      shellHook = ''
        # Initialize opam environment if it exists
        if [ -f ~/.opam/opam-init/init.sh ]; then
          eval $(opam env)
        fi

        # environment variables for build tools and stuff
        export RISCV=${pkgs.pkgsCross.riscv64.buildPackages.gcc}/
        export PATH=$RISCV/bin:$PATH
        # Help opam find system libraries
        export PKG_CONFIG_PATH="${pkgs.gmp.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
        export C_INCLUDE_PATH="${pkgs.gmp.dev}/include:$C_INCLUDE_PATH"
        export LIBRARY_PATH="${pkgs.gmp}/lib:$LIBRARY_PATH"
        export DV_SIMULATORS=veri-testharness,spike
        export VERILATOR=$PWD/riscv-implementations/cheri-cva6/tools/verilator-v5.038/bin/verilator
        export VERILATOR_INSTALL_DIR=$(dirname $(dirname $VERILATOR))

        echo "RISC-V toolchain: $RISCV"
        echo "Verilator path: $VERILATOR_ROOT"
        # Create and activate venv
        if [ ! -d .venv ]; then
          python3 -m venv .venv
        fi
        source .venv/bin/activate
        echo "Development environment loaded"
      '';
    }
