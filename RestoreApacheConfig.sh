sudo apachectl stop
sudo rm -rf /private/etc/apache2/ssl
sudo rm -rf /private/etc/apache2/httpd.conf
sudo rm -rf /private/etc/apache2/extra/httpd-ssl.conf
sudo cp -f /private/etc/apache2/original/httpd.conf /private/etc/apache2/httpd.conf
sudo cp -f /private/etc/apache2/original/extra/httpd-ssl.conf /private/etc/apache2/extra/httpd-ssl.conf
sudo security delete-certificate -c localhost
sudo security delete-certificate -c localhost
echo 'Original Apache configuration was restored'