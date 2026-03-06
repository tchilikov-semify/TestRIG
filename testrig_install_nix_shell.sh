echo "I am here: $PWD"

# Initialize opam
opam init --bare -y
opam switch create testrig 4.14.1
eval $(opam env)

# Install Sail dependencies
opam install -y sail menhir lem linksem z3 ott linenoise

# Build the QuickCheck Verification Engine
make vengines

# Build Sail and CVA6 RISC-V models
make sail-rv64-cheri
make cva6-rv64xcheri

# Checkout zcheri branch for CVA6, and pull to recent version to get the correct testbench
cd riscv-implementations/cheri-cva6
git checkout zcheri
git pull

# Initialize CVA6 submodules
git submodule update --init --recursive


# Build Verilator
cd tools/verilator-v5.038/build-v5.038
autoconf
./configure --prefix=$PWD/..
make -j$(nproc)
make install

# confirm verilator was built
./bin/verilator --version

cd ..

# Go to root of CVA6
cd ../../

# Install Python requirements
pip3 install -r verif/sim/dv/requirements.txt

# Patch the lib.py file to replace all occurences of /bin/bash with just bash
cp verif/sim/dv/scripts/lib.py verif/sim/dv/scripts/lib.py.bak
sed -i "s|/bin/bash|bash|g" verif/sim/dv/scripts/lib.py

# Final tests
# Go to TestRIG root rfolder
cd ../../
echo "PWD: $PWD"
echo "Installation finished!"
echo "Run default TestRIG simulation to see whether everything is working or not:"
utils/scripts/runTestRIG.py -a sail -b cva6 -r rv64icxcheri --relaxed-comparison --test-exclude-regex unstructured
