#!/usr/bin/env bash

ssh -i $SSH_PATH $USERNAME@$IP_ADDRESS <<- EOF
	sudo apt update -y && \
	sudo apt install -y nginx
	sudo systemctl enable --now nginx
EOF
