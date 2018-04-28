THIRD_DIR=$(pwd)

sudo apt install libinput-tools xdotool wmctrl

cd libinput-gestures
echo "installing libinput-gestures"
sudo make install
cd $THIRD_DIR

./matcha/Install
