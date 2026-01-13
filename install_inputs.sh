echo "Downloading and extracting Parsec simulation inputs..."
wget https://github.com/ChrisYzcc/parsec-riscv/releases/download/v0.0.1/parsec-sim-inputs.tar.gz -O parsec-sim-inputs.tar.gz
tar -xzvf parsec-sim-inputs.tar.gz --strip-components=1
