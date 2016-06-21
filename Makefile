DOCKER_PSQL="docker-compose exec postgres psql -U zotonic"
SSH_USER=$(shell whoami)
REMOTE_SITES_DIR=/srv/zotonic/sites
REMOTE_BACKUP_PATH=$(REMOTE_SITES_DIR)/$(site)/files/backup
REMOTE_BACKUP_FILE=$(shell ssh $(SSH_USER)@$(host) ls "$(REMOTE_BACKUP_PATH)/*.sql" -t | head -n1 | xargs -n1 basename)

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  gulp site=your_site   Run Gulp in a site directory"
	@echo "  import-db-file        Import database from file (db=site-name file=site-dump.sql)"
	@echo "  import-db-backup      Import database from a backup (host=ginger.driebit.net site=site-name)"
	@echo "  shell                 Open Zotonic shell"
	@echo "  up                    Start containers"
	@echo "  up-zotonic            Start containers with custom Zotonic checkout"
	@echo "  update                Update containers"

gulp $(site):
	# Env MODULES_DIR can be used in Gulpfiles, if necessary.
	docker run -it -v `pwd`/sites/$(site):/app -v `pwd`/modules:/modules --env MODULES_DIR=/modules driebit/node-gulp

import-db-file $(db) $(file):
	@echo "> Importing $(db) from $(file)"
	@docker-compose stop zotonic
	@docker-compose up -d postgres
	@docker-compose exec postgres psql -U zotonic -c "DROP DATABASE IF EXISTS $(db)"
	@docker-compose exec postgres psql -U zotonic -c "CREATE DATABASE $(db) ENCODING 'UTF8' TEMPLATE template0"
	@docker-compose exec postgres psql $(db) -U zotonic -h localhost -f $(file)
	$(MAKE) up

import-db-backup $(host) $(site):
	@echo "> Importing $(REMOTE_BACKUP_FILE) from $(host) into $(site)"
	@scp $(ssh_user)@$(host):$(REMOTE_BACKUP_PATH)/$(REMOTE_BACKUP_FILE) data/
	@$(MAKE) import-db-file db=$(site) file=$(REMOTE_BACKUP_FILE)

shell:
	@docker-compose exec zotonic zotonic shell

up:
	@docker-compose up --build
	@echo "> Started. Open http://localhost in your browser."

up-zotonic:
	@docker-compose -f docker-compose.yml -f docker-compose.zotonic.yml up --build
	@echo "> Started. Open http://localhost in your browser."

update:
	@docker-compose pull
