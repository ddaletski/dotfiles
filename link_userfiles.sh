find userconf -maxdepth 1 -type f | xargs -i ln -sf "$(pwd)/{}" ~/  
