docker run --name mysql-rds -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 mysql

docker build -t test-drive ^
  --build-arg host_name="cloudbreathe.in" ^
  --build-arg db_host=host.docker.internal ^
  --build-arg db_user=root ^
  --build-arg db_pass=root ^
  --build-arg site_name="Test Drive" ^
  --build-arg short_site_name="test-drive" ^
  --build-arg admin_user="user" ^
  --build-arg admin_pass="bitnami" .

docker run --name test-drive -d -p 443:443 test-drive