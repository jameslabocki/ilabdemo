#!/bin/bash
# This script can be run on an InstructLab instance from demo.redhat.com to fix the issues with training and
# also deploy the parasol insurance claims application

#Navigate to home directory
cd ~
rm -rf ~/instructlab
rm -rf ~/.cache/pip
git clone https://github.com/instructlab/instructlab.git@v0.17.1
cd instructlab
python -m venv venv
source venv/bin/activate
pip install .
#Need to change linux_train.py
# was: tokenizer.eos_token
# change to: tokenizer.unk_token
sed -i.bak 's/tokenizer.eos_token/tokenizer.unk_token/' ~/instructlab/venv/lib/python3.11/site-packages/instructlab/train/linux_train.py

pip install .
pip install --force-reinstall "llama_cpp_python[server]==0.2.79" --config-settings  cmake.args="-DLLAMA_CUDA=on"
pip install 'numpy<2.0'
pip install instructlab-schema
rm -rf ~/files
mkdir ~/files
curl -o ~/files/qna.yaml https://raw.githubusercontent.com/gshipley/backToTheFuture/main/qna.yaml
# the following command assums you have the model file in the files directory
# the model can be downloaded from gdrive at https://drive.google.com/file/d/14EwNWVP5qGFD4zM-s-wscD4lYHCMU5at/view?usp=sharing
cp -av /home/instruct/files/summit-connect-merlinite-7b-lab-Q4_K_M.gguf /home/instruct/instructlab/models/
sudo dnf install zip
curl -s "https://get.sdkman.io" | bash
source "/home/instruct/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.3-tem
cd ~
git clone https://github.com/rh-rad-ai-roadshow/parasol-insurance.git
cd parasol-insurance/app
./mvnw clean package -DskipTests
java -jar -Dquarkus.langchain4j.openai.parasol-chat.base-url=http://localhost:8000/v1 target/quarkus-app/quarkus-run.jar
