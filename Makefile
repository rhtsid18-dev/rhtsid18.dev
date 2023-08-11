create_local_certs:
	chmod +x ./generate_certs.sh
	./generate_certs.sh

up:
	docker-compose up -d

down:
	docker-compose down
