RESOURCES_DIR=$(pwd)

cd /usr/share/icons
for theme in $(ls $RESOURCES_DIR/icons/*.tar.gz); do sudo tar -xf $theme; done
cd $RESOURCES_DIR
sudo cp backgrounds/* /usr/share/backgrounds/
