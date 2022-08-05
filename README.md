# Basic Docker Image with PHP 5.6 and Oracle

A basic development environment ready to use with PHP 5.6 and Oracle

## Getting Started

You need to use only two commands:

### First:

```
docker build -t felpscouto/docker-php-5.6-oracle .
```

### Last:

```
docker run -p 8080:80 -d -v ${pwd}/app:/var/www/html felpscouto/docker-php-5.6-oracle
```

Enjoy! 😁
