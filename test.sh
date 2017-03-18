#!/bin/bash

cd ./main_server

jshint main_server.js
eslint main_server.js

jshint ../load_balancer/load_balancer.js
eslint ../load_balancer/load_balancer.js

jshint ../execution_nodes/execute_node.js
eslint ../execution_nodes/execute_node.js

grep -rl --exclude-dir=node_modules '/etc' .. | xargs sed -i 's/\/etc/\.\.\/deploy\/configs/g'
rm ../execution_nodes/extract_run.sh
mv ../execution_nodes/extract_run_test.sh ../execution_nodes/extract_run.sh

chmod +x main_server.js

npm install
node main_server.js&
sleep 20

cd ../load_balancer
chmod +x load_balancer.js

npm install
node load_balancer.js&
sleep 20

cd ../execution_nodes
chmod +x execute_node.js

npm install
node execute_node.js&
sleep 20

curl --ipv4 -k https://127.0.0.1:9000

cd ../Test
chmod +x submit.js

npm install minimist
npm install cli-table
npm install socket.io-client
node submit.js -i 2015A7PS006G -l labtest&
sleep 20



