pandoc -S -o Guidelines_EnergyADE.pdf \
    --listings \
    --template template1 \
    --filter pandoc-citeproc \
    Guidelines_EnergyADE.md metadata.yaml

mv Guidelines_EnergyADE.pdf ../Guidelines_EnergyADE.pdf 
