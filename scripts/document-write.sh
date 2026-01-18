#!/usr/bin/env bash

ssh -i $SSH_PATH $USERNAME@$IP_ADDRESS <<- EOF
	sudo tee /var/www/html/index.nginx-debian.html <<- EOL
		<!DOCTYPE html>
		<html lang='en'>
		<head>
  			<meta charset='UTF-8'>
  			<meta name='viewport' content='width=device-width, initial-scale=1.0'>
  			<title>Hello World</title>
		</head>
		<body>
  			<h1>Hello World!</h1>
  			<p>Today's date is: $(date +"%d/%m/%Y") </p>
		</body>
		</html>
	EOL
EOF
