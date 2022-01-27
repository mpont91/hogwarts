.PHONY: fetch
fetch:
	git fetch
	git reset --hard origin/master

.PHONY: build
build:
	npm --silent ci --no-progress
	npm run build

.PHONY: deploy
deploy:
	pm2 start

.PHONY: production
production:
	make fetch
	make build
	make deploy

.PHONY: install
install:
	ssh -q root@mpont91.com 'cd /var/www/hogwarts && make production'
