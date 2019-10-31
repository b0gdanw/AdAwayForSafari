echo 'Step 1: Generating key and certificate'
sudo mkdir /private/etc/apache2/ssl
cd /private/etc/apache2/ssl
sudo openssl genrsa -out localhost.key 2048
sudo openssl req -new -x509 -key localhost.key -out localhost.crt -days 3650 -subj /CN=localhost
echo 'Step 2: Adding key and certificate to Keychain'
sudo security add-trusted-cert -r trustRoot -p ssl -e hostnameMismatch -k ~/Library/Keychains/login.keychain localhost.crt
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain localhost.crt
echo 'Step 3: Editing Apache configuration'
sudo sed -i '' "s/#LoadModule ssl_module/LoadModule ssl_module/" /private/etc/apache2/httpd.conf
sudo sed -i '' "s/#LoadModule socache_shmcb_module/LoadModule socache_shmcb_module/" /private/etc/apache2/httpd.conf
sudo sed -i '' "s/#ServerName www.example.com:80/ServerName localhost:80/" /private/etc/apache2/httpd.conf
sudo sed -i -e '/localhost:80/a\'$'\n''ServerName localhost:443' /private/etc/apache2/httpd.conf
sudo sed -i '' '/connections/{G;}' /private/etc/apache2/httpd.conf
sudo sed -i -e '/connections/a\'$'\n''Include /private/etc/apache2/extra/httpd-ssl.conf' /private/etc/apache2/httpd.conf
sudo sed -i '' "s/www.example.com/localhost/" /private/etc/apache2/extra/httpd-ssl.conf
sudo sed -i '' "s~server.crt~ssl/localhost.crt~" /private/etc/apache2/extra/httpd-ssl.conf
sudo sed -i '' "s~server.key~ssl/localhost.key~" /private/etc/apache2/extra/httpd-ssl.conf
sudo sed -i '' "s/_default_/localhost/" /private/etc/apache2/extra/httpd-ssl.conf
echo 'Step 4: Apache configtest'
sudo apachectl configtest
echo 'Step 5: Starting Apache'
sudo apachectl start
echo 'Done'