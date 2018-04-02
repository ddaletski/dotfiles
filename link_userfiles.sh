find userconf -maxdepth 1 -type f | xargs -i ln -sf "$(pwd)/{}" ~/  
ln -sf $(pwd)/userconf/.i3 ~/.i3
