#!/bin/sh

echo "About to fire up two docker instances: mondrian_demo_mysql_instance and mondrian_demo_instance."
echo
sleep 10

docker build -t mondrian_demo_mysql -f Dockerfile.mysql .
docker run --rm -d --name mondrian_demo_mysql_instance mondrian_demo_mysql
docker build -t mondrian_demo .
docker run --rm --link mondrian_demo_mysql_instance:db -d -p 3000:3000 --name mondrian_demo_instance mondrian_demo

echo
echo "Fired up two docker instances:"
docker ps | grep mondrian
echo
echo "Check out the app at http://localhost:3000/ - but give it several seconds, it's loading a lot of data."
