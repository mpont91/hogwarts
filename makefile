all:
	npm --silent ci --no-progress
	npm run build

production:
	git pull
	make

install:
	ssh -q root@mpont91.com 'cd /var/www/hogwarts && make production && pm2 start'
