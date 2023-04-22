# cd_assignment
[![Deploy Pipeline](https://github.com/bokorrel/cd_assignment/actions/workflows/pipeline.yml/badge.svg)](https://github.com/bokorrel/cd_assignment/actions/workflows/pipeline.yml)

This repo is created for an assignment of the WincAcademy Back-end Development course. It creates a simple application/website on a Linux Virtual Private Server (VPS). 

## Application 
You can access the final application with the following URL: http://68.183.15.232/

## VPS service
The application has it's own service on the VPS (alongside the 'farm' service we had to create in a previous exercise). The service can be found on the VPS on the following location: 
> /etc/systemd/system/cd_assignment.service

### Service config
   <pre><code>
   [Unit]
   # This could be anything that helps you and colleagues know what this
   # service is for.
   Description=cd assignment

   # This tells systemd when this application is ready to start
   After=network.target

   [Service]
   Type=notify
   DynamicUser=yes
   RuntimeDirectory=cd_assignment

   # Where the command supplied in ExecStart be run
   WorkingDirectory=/home/cd_assignment/
   ExecStart=/usr/local/bin/gunicorn main:app
   ExecReload=/bin/kill -s HUP $MAINPID
   Restart=on-failure
   KillMode=mixed
   TimeoutStopSec=5
   PrivateTmp=true

   [Install]
   WantedBy=multi-user.target
   </code></pre>


## Components 
The main focus of this repo is the **deployment pipeline**, which includes a few noteworthy components:
1. pytest

   The first job of the deployment pipeline is the *run-tests* job, in this job the code will be testing using *pytest*. Pytest is a python module and is therefore not default accessible from Github. Thats why we first need to install the pytest module, this is only possible if Python is installed and if Python has access to the *requirements.txt* file. This is made possible by checking out the github repository first (with the use of actions/checkout@v3 action), in that way the *requirements.txt* file can be read and Python knows what version of  pytest to install. Finally, the pytest command will be executed to trigger all test files in the repo. 

2. needs

   New or adjusted code that is pushed to this repository should only be deployed to the VPS if all tests were successfull, that's why I used the 'needs' function      inside the deployment pipeline to only run the *deploy-code* job if the *run-test* job was successfull.

3. appleboy/ssh-action 

   The second job of the deployment pipeline is the *deploy-code* job, for which I made use of appleboy/ssh-action. This action connects to the VPS with SSH authentication and runs commands on the VPS. Any command can be entered, but in this job we use it to deploy the pushed code onto the VPS, so that the changes will reflect to the application.
   

## Challenges
1. For running commands on the VPS I needed SSH keys to connect, but SSH authentication was new to me, so at first I made the mistake to follow an article    about adding SSH keys to Github with you Github emailaddress:
   > ssh-keygen -t ed25519 -C "youremail@hotmail.com"
   
   I added the private key of this SSH key pair to my Github SSH keys (on account level), but later on I found out that this was not what I needed. I wanted    to give Github access to my VPS, but with the above configuration I gave the VPS write access to my Github instead. 
   That's why I deleted this SSH key pair and generated a new pair with the following command:
   
   > ssh-keygen
   
3. After generating the new SSH key pair I added the private key to the Secrets of this repo, but at first I kept getting the following error:
   > ssh.ParsePrivateKey: ssh: no key found
   
   Which lead to the error: 
   > ssh: handshake failed: ssh: unable to authenticate, attempted methods [none], no supported methods remain

   I solved this by copying the entire content of the private key into the Github Secret. Starting from and including the comment section -----BEGIN OPENSSH    PRIVATE KEY----- ....... to -----END OPENSSH PRIVATE KEY-----. Apparently appleboy needs this comment sections to be included in the key to establish a      valid SSH connection. Credits goes to chinedu117 who shared this solution on: https://github.com/appleboy/ssh-action/issues/6
   
3. Also at first it was hard to find a way to run my bash (.sh) file, I kept getting the following error:
   > err: sh: 0: Can't open deploy_files.sh
   
   I fixed this by checking the current location with this command:
   > pwd

   And after I found out that the code was ran from inside the /root/ folder directly, I knew how to reach my bash file and run it:
   > sh /home/cd_assignment/deploy_files.sh

# Notes
Although I use pytest to test the code, making pytests scripts was not the focus of tis assignment, so I did not spent any effort into this. The pytest script is only an easy way to let the *run-tests* job succeed or fail in order to see how the deployment pipeline will react to this.  
The same applies for the application itself, its as minimal as possible.
