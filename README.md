# UltraNoteI-Cloud
UltraNote Infinity Cloud Wallet

## Installing Frontend
- cd UltraNoteI-Cloud/cryptwallet
- nvm install 14
- nvm use 14.19.0
- npm install
- npm run build
- mv build /var/www/Cloud
- chown -R www-data:www-data /var/www

Edit .htaccess file and activate https
- nano /var/www/Cloud/.htaccess

## Building Backend 

- cd UltraNoteI-Cloud/Backend
- npm install

## Run Backend
- Using pm2: pm2 start ./index.js --name=backend
