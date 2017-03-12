#!/bin/bash

cd main_server
sudo npm install

cd ../execution_nodes
sudo npm install 

cd ../load_balancer
sudo npm install

sudo npm install -g jshint
sudo npm install -g eslint

cd ../main_server

jshint main_server.js
eslint main_server.js

jshint ../load_balancer/load_balancer.js
eslint ../load_balancer/load_balancer.js

jshint ../execution_nodes/execute_node.js
eslint ../execution_nodes/execute_node.js

chmod +x main_server.js

sudo apt-get install iptables
sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT
sudo /etc/init.d/iptables restart

node main_server.js
curl http://localhost:9000
