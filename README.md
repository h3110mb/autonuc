# autonuc


Automating Nuclei to find low hanging fruits.

# Pre-requisites:

> GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei


> GO111MODULE=on go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder


> GO111MODULE=on go get -u -v github.com/lc/gau


> wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux; mv findomain-linux findomain; chmod +x findomain;


> go get -u github.com/tomnomnom/assetfinder


> GO111MODULE=on go get -v github.com/projectdiscovery/shuffledns/cmd/shuffledns


***Change the path according to your nuclei-templates location.***

# Usage:

>bash nuclei.sh target.com

# Credits:
***CREDIT GOES TO ALL CREATORS OF RESPECTIVE TOOLS***
