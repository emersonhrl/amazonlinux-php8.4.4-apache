## DOCKER BUILD
docker build -t amazonlinux-php8.4.4-apache:2023.6.20250218.2 .
## DOCKER RUN
docker run -d -p 80:80 --name my-app -v "$PWD":/usr/local/apache2/htdocs amazonlinux-php8.4.4-apache::2023.6.20250218.2
