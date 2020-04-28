# Hugo Bootstrap

### Summary

[Hugo](https://gohugo.io) is a framework to create static websites, written in GO. T 

The `deploy.sh` script is aimed at setting up any new github repo to 
create a new static website using hugo and automatically deploy it 
to gihub pages, address <username>.github.io/<repo>

### Instructions

#### Tools

You will need the following tools installed

Tool 		|	`cmd` 
------------|----------
git 	 	|	`git`
hugo 	 	|	`hugo`

#### Commands

Here is a basic workflow example:

```bash
# Create a new EMPTY repo on your github and clone it
git clone https://github.com/<user>/<repo>.git

# Download this script and make it executable
curl -fsSL https://raw.githubusercontent.com/d-asnaghi/hugo-template/master/deploy.sh >> deploy.sh
chmod +x deploy.sh

# Run the script to bootstrap the website
./deploy.sh

# By default the script will install the vanilla theme
# make any modifications to your website, you can add
# content and edit it, or change the theme.

# Run the script again to actually publish the website to git pages
./deploy.sh

```

You can now checkout your live website at <username>.github.io/<repo>
