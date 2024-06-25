#!/bin/bash
# This script can be run on an InstructLab instance from demo.redhat.com to fix the issues with training and
# also deploy the parasol insurance claims application

# After this script is run you should be able to do the following to run the parasol insurance app
# You can now change directories with cd ~/parasol-insurance/app
# Then you can source ~/.bashrc
# Then you can quarkus dev to launch the parasol-insurance app
# Then you can navigate to the app on port 8005 (use http, not https)

# Also after this script is run you should be able to do the following with instructlab to retrain the model on the delorean
# cd ~/instructlab
# source venv/bin/activate
# ilab init
# ilab download
# mkdir -p ~/instructlab/taxonomy/knowledge/parasol/overview
# cp files/qna.yaml ~/instructlab/taxonomy/knowledge/parasol/overview/qna.yaml
# ilab diff
# ilab generate --num-instructions 200
# ilab train --iters 300 --device cuda
# ilab serve --model-path ./models/ggml-model-f16.gguf
# ilab chat
# You may want to ask "how much does it cost to repair a flux capacitor in a delorean?"
# Now you can go back to the Parasol app and test to see if your newly served model is spitting out better answers

#Navigate to home directory
cd ~

#remove pip cache and venv and start over. Not sure why, but if
#we don't do this we hit weird errors involving knowledge.json 
#not existing in the schema when running ilab diff
rm -rf ~/instructlab
rm -rf ~/.cache/pip
mkdir ~/instructlab
cd ~/instructlab
python -m venv venv

#source venv
source venv/bin/activate

#Upgrade InstructLab
pip install instructlab

#Need to change linux_train.py
# was: tokenizer.eos_token
# change to: tokenizer.unk_token
sed -i.bak 's/tokenizer.eos_token/tokenizer.unk_token/' ~/instructlab/venv/lib/python3.11/site-packages/instructlab/train/linux_train.py

#Need to pip install after making the previous change
pip install .

#Need new llama_cpp_python for things to work properly
#This runs a LONG time for some reason
pip install --force-reinstall "llama_cpp_python[server]==0.2.79" --config-settings  cmake.args="-DLLAMA_CUDA=on"

#downgrade numpy or you'll get a breaking change to ilab training
pip install 'numpy<2.0'

# Getting instructlab qna.yaml for backtothefuture example
mkdir ~/files
curl -o ~/files/qna.yaml https://raw.githubusercontent.com/gshipley/backToTheFuture/main/qna.yaml

#Now lets install the parasol insurance app 

# ensure we are in home directory
cd ~

# Install zip
echo "installing zip"
sleep 1
sudo dnf install zip -y

# Install sdkman in order to get newer versions of Java and Maven. Then install Quarkus, Java, and Maven.
echo "installing sdkman"
sleep 1
curl -s "https://get.sdkman.io" | bash
source "/home/instruct/.sdkman/bin/sdkman-init.sh"
sdk install quarkus
sdk install java 22.0.1-tem
sdk install maven

# Clone parasol app
echo "cloning parasol-insurance"
sleep 1
git clone https://github.com/jamesfalkner/parasol-insurance.git



