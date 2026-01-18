# ACIT-4640 - Lab 2

In this lab we go over the basics for using heredocs to ssh into an ec2 instance and setting up an nginx config.

##### Creating an SSH Key

Before we start, we should always create a fresh SSH key for our EC2 instance.

We're going to run the code below in our WSL terminal, or whatever Linux host machine we're using.

`ssh-keygen -t ed25519 -f ~/.ssh/wkone -C "lab2"`

`-t ed25519` Specifies to use ed25519 encryption
`-f ~/.ssh/wkone` Specifies the file location for the key
`-C "lab2"` Is a comment for this key

Now you're going to create an AWS EC2 instance and attach the .pub portion of this key to the new virtual machine.

##### Setting Environment Variables

On our host machine, we're going to create a file with some environment variables within it.

Use nano, or the text editor of your choice to create a file called "env_var" with the following contents:

```bash
export USERNAME="admin"
export IP_ADDRESS="<YOUR_EC2_IP>"
export SSH_PATH="~/.ssh/wkone"
```

Then run the command `sudo chmod +x env_var` and `source env_var` to load these environment variables onto your system. We will reference them in the following two scripts to make our scripts a bit cleaner.

##### Nginx Install

Once again, use your text editor to create the following file called "nginx-install.sh":

```bash
#!/usr/bin/env bash
# The shebang on line one is used to specify which interpreter to use

# Env variables to ssh onto our EC2 and run the nginx install
ssh -i $SSH_PATH $USERNAME@$IP_ADDRESS <<- EOF
        sudo apt update -y && \
        sudo apt install -y nginx
        sudo systemctl enable --now nginx
EOF
```

In the script, we use a heredoc to essentially run the three nginx install lines through the ssh command onto our EC2 instance.

`-i` allows us to specify the location of our private key
`-` after the `<<` indicates to ignore tab indentations in the heredoc itself, making our code cleaner
`EOF` is our delimiter, which can be set to anything and will close out our script afterwards

##### Nginx Index Html

Create another file called "document-write.sh":

```bash
#!/usr/bin/env bash
# The shebang on line one is used to specify which interpreter to use

# Env variables to ssh onto our EC2 and change the index html for nginx
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
```

The base principles of this script are the same as the nginx-install.sh script from before, but instead we're using a nested heredoc to push a new html into the index page once on the EC2.

We use `sudo tee` instead of a `cat` command heredoc, since we can run into permission issues when using `cat` to update the text in the file.

Another notable part of this text is the command substitution in the body of the html.

`$(date +"%d/%m/%Y")` inputs the current date in the format D/M/YYYY onto the body of our index page.

#### Running the commands

Before running the two scripts, be sure to run the `chmod +x <SCRIPT>` on both `nginx-install.sh` and `document-write.sh` so they can be executed.

Afterwards, we can just type `./nginx-install.sh` and then `./document-write.sh` to execute our commands onto our EC2 and check that our webpage is online and has the new content with our current date.