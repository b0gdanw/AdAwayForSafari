echo 'Step 1: Get hosts files'
mkdir whosts
cd whosts
# Host 1
curl -O https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt
mv hosts.txt hosts1.txt
if [ -f hosts1.txt ]; then
  echo '--> adaway.org saved';
fi
# Host 2
curl -O https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
mv hosts hosts2.txt
if [ -f hosts2.txt ]; then
  echo '--> hosts-file.net saved';
fi
# Host 3
curl -O https://winhelp2002.mvps.org/hosts.txt
mv hosts.txt hosts3.txt
if [ -f hosts3.txt ]; then
  echo '--> winhelp2002.mvps.org saved';
fi
# Host 4
curl -O "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
mv serverlist.php\?hostformat\=hosts\&showintro\=0\&mimetype\=plaintext hosts4.txt
if [ -f hosts4.txt ]; then
  echo '--> pgl.yoyo.org saved';
fi
# Host 5
curl -O https://raw.githubusercontent.com/davidonzo/Threat-Intel/master/lists/latestdomains.piHole.txt
mv latestdomains.piHole.txt hosts5.txt
if [ -f hosts5.txt ]; then
  echo '--> DigitalSide Threat-Intel saved';
fi
# Host 6
curl -O https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt
mv hosts.txt hosts6.txt
if [ -f hosts6.txt ]; then
  echo '--> nocoin-list saved';
fi
echo 'Step 2: merge files into new host file'
cat hosts1.txt >> hosts
cat hosts2.txt >> hosts
cat hosts3.txt >> hosts
cat hosts4.txt >> hosts
cat hosts5.txt >> hosts
cat hosts6.txt >> hosts
echo 'Step 3: replace special entries'
sed -i '' '/localhost/d' hosts
sed -i '' '/broadcasthost/d' hosts
sed -i '' '/local/d' hosts
sed -i '' 's/127.0.0.1/0.0.0.0/' hosts
echo 'Step 4: clean the file'
sed -i '' '/^ /d' hosts
sed -i '' '/^#/d' hosts
sed -i '' '/^[[:space:]]*$/d' hosts
sed -i '' 's/^0.0.0.0 //g' hosts
sed -i '' 's/0.0.0.0	//g' hosts
sed -i '' 's/[[:space:]]//g' hosts
sed -i '' 's/#.*//' hosts
echo 'Step 5: delete duplicates'
awk '!seen[$0]++' hosts > hosts_ls
echo "Step 7: starting conversion"
echo '{
  "name": "AdAway for Safari",
  "description": "AdAway for Safari",
  "rules": [' >> AdAwayForSafari.lsrules

while IFS= read -r line;do
    echo '{
      "action" : "deny",
      "process" : "\/Applications\/Safari.app\/Contents\/MacOS\/Safari",
      "remote-domains" : "'$line'"
    },' >> AdAwayForSafari.lsrules
done < "hosts_ls"
sed -i '' -e '$ d' AdAwayForSafari.lsrules
echo '}
  ]
}' >> AdAwayForSafari.lsrules
cd ..
read -p "Copy AdAwayForSafari.lsrules to /Library/WebServer/Documents/ (y/n)?" choice
case "$choice" in 
  y|Y )
sudo rm -f /Library/WebServer/Documents/AdAwayForSafari.lsrules
sudo cp -f whosts/AdAwayForSafari.lsrules /Library/WebServer/Documents/AdAwayForSafari.lsrules
echo "AdAwayForSafari.lsrules was placed in /Library/WebServer/Documents/"
;;
  n|N )
cp whosts/AdAwayForSafari.lsrules AdAwayForSafari.lsrules
echo "AdAwayForSafari.lsrules was saved in your home folder"
;;
  * ) echo "Invalid choice";;
esac
echo 'Remove temporary files'
rm -r whosts
echo 'Please update AdAway for Safari in Little Snitch Configuration'
open /Applications/Little\ Snitch\ Configuration.app
