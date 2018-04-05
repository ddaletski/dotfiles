THIRD_DIR=$(pwd)


cd libinput-gestures
echo "installing libinput-gestures"
sudo make install
cd $THIRD_DIR

./matcha/Install
