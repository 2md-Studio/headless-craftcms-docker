CONTAINER?=$(shell basename $(CURDIR))-php-1
# BUILDCHAIN?=$(shell basename $(CURDIR))-webpack-1

.PHONY: build clean composer dev npm pulldb restoredb up

# build: up
# 	docker exec -it ${BUILDCHAIN} npm run build
clean:
	docker-compose down -v
	docker-compose up --build
composer: up
	docker exec -it ${CONTAINER} composer \
		$(filter-out $@,$(MAKECMDGOALS))
craft: up
	docker exec -it ${CONTAINER} php craft \
		$(filter-out $@,$(MAKECMDGOALS))
dev: up
npm: up
	docker exec -it ${BUILDCHAIN} npm \
		$(filter-out $@,$(MAKECMDGOALS))
pulldb: up
	cd scripts/ && ./docker_pull_db.sh
restoredb: up
	cd scripts/ && ./docker_restore_db.sh \
		$(filter-out $@,$(MAKECMDGOALS))
update:
	docker-compose down
	rm -f cms/composer.lock
	docker-compose up
update-clean:
	docker-compose down
	rm -f cms/composer.lock
	rm -rf cms/vendor/
	docker-compose up
up:
	if [ ! "$$(docker ps -q -f name=${CONTAINER})" ]; then \
        docker-compose up; \
    fi
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
