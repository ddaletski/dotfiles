#!/bin/bash

sudo apt install -y $(cat utils-ubuntu)

cat apps-snap | parallel -n1 echo 'sudo snap install {}' | parallel -n1
