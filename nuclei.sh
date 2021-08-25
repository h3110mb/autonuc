#!/bin/bash

mkdir  -p $1/{recon,nuclei}
echo  "***************************************************************************"

echo "Gathering Subdomain"
echo "***************************************************************************"
subfinder -silent -d $1 > $1/recon/Subdomain.txt 
gau -subs $1 | cut -d / -f 3 | cut -d ":" -f 1| sort -u >> $1/recon/Subdomain.txt 
assetfinder -subs-only $1 >> $1/recon/Subdomain.txt 
findomain -t $1 -q -u $1/recon/findomain.txt
for domain in $(cat $1/recon/findomain.txt);do findomain -t $domain -q ;done >> $1/recon/Subdomain.txt 
shuffledns -w $1/recon/Subdomain.txt  -r ~/tools/resolvers.txt

echo "Sorting Subdomain"
echo "***************************************************************************"
cat $1/recon/Subdomain.txt| sort -u | uniq > $1/recon/Final_subdomain.txt


echo "Testing for Alive Subdomains"
echo "***************************************************************************"

cat $1/recon/Final_subdomain.txt| httpx -silent > $1/recon/ALive.txt
cat $1/recon/ALive.txt | sed -e 's/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/' | tee $1/recon/nmap_target.txt


echo "Sending all URLs to Nuclei|Sit Back and Relax"
echo "***************************************************************************"

echo "Testing for CVEs"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/cves/ -silent -c 20 -o $1/nuclei/cve.txt

echo "Testing for Subdomain Takeover"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/takeovers/ -silent -c 20 -o $1/nuclei/subtko.txt

echo "Testing for security misconfiguration"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/misconfiguration/ -silent -c 20 -o $1/nuclei/sec_misconfig.txt

echo "Testing for Files"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/exposures/files/  -silent -c 20 -o $1/nuclei/Files.txt

echo "Testing for Vulnerabilities "
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/vulnerabilities/ -silent -c 20 -o $1/nuclei/Vuln.txt

echo "testing for Default Logins"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/default-logins/ -silent -c 20 -o $1/nuclei/Default.txt

echo "Testing Miscellaneous"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/miscellaneous/ -silent -c 20 -o $1/nuclei/misc.txt

echo "backup Files"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/exposures/backups/ -silent -c 20 -o $1/nuclei/backup.txt

echo "DNS"
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/dns/ -silent -c 20 -o $1/nuclei/DNS.txt

echo "Testing for Exposures "
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/exposures/ -silent -c 20 -o $1/nuclei/exposures.txt

echo "Testing for exposed-panels "
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/exposed-panels/ -silent -c 20 -o $1/nuclei/panels.txt

echo "Testing for exposed-tokens "
echo "------------------------------------------------------"
nuclei -l $1/recon/Final_subdomain.txt -t ~/nuclei-templates/exposed-tokens/ -silent -c 20 -o $1/nuclei/tokens.txt