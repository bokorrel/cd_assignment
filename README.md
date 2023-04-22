# cd_assignment
[![Deploy Pipeline](https://github.com/bokorrel/cd_assignment/actions/workflows/pipeline.yml/badge.svg)](https://github.com/bokorrel/cd_assignment/actions/workflows/pipeline.yml)

This repo is created for an assignment of the WincAcademy Back-end Development course. It creates a simple application/website on a Linux Virtual Private Server (VPS). 

## Application 
You can access the final application with the following URL: http://68.183.15.232/ (TODO: CHANGE URL!!)

## VPS service
The application has it's own service on the VPS (alongside the 'farm' service we had to create in a previous exercise). The service can be found on the VPS on the following location: */etc/systemd/system/cd_assignment.service*

### Service config




## Components 
Name three components of your solution, explain what they are and how they relate to each other. A 'component' can be anthing from GitHub Actions or Bash to Digital Ocean and SSH.

The main focus of this repo is the **deployment pipeline**, which includes a few noteworthy components:
1. appleboy/ssh-action 
2. ....
3. .....


Discuss three problems that you encountered along the way and how you solved them.
## Challenges
1. SSH keys were new to me, so at first I made the mistake to follow an article about adding SSH keys to Github with you Github emailaddress:
   > ssh-keygen -t ed25519 -C "youremail@homtmail.com"
   
   I added the private key of this SSH key pair to my Github SSH keys (on account level), but later on I found out that this was not what I needed. I wanted    to give Github access to my VPS, but with the above configuration I gave the VPS write access to my Github instead. 
   That's why I deleted this SSH key pair and generated a new pair with the following command:
   
   > ssh-keygen
   
3. For running commands on the VPS I added the SSH private key to the Secrets of this repo, but at first I kept getting the following error:
   > ssh.ParsePrivateKey: ssh: no key found
   
   Which lead to the error: 
   > ssh: handshake failed: ssh: unable to authenticate, attempted methods [none], no supported methods remain

   I solved this by copying the entire content of the private key into the Github Secret. Starting from and including the comment section -----BEGIN OPENSSH    PRIVATE KEY----- ....... to -----END OPENSSH PRIVATE KEY-----. Apparently appleboy needs this comment sections to be included in the key to establish a      valid SSH connection. Credits goes to chinedu117 who shared this solution on: https://github.com/appleboy/ssh-action/issues/6
   
3. Also at first it was hard to find a way to trigger my bash (.sh) file, I kept getting the following error:
   > err: sh: 0: Can't open deploy_files.sh
