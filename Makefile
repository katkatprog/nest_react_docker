include .env

########################################################################################
################################# 共通コマンド ###########################################
########################################################################################
#	環境の起動
up:
	docker-compose up

# 環境の動作終了
down:
	docker-compose down

# 環境の再起動
restart:
	@make down
	@make up

# imageの作成(build)
build:
	docker-compose build --no-cache

########################################################################################
################################# frontに関するコマンド ######################################
########################################################################################
# frontコンテナにアクセスする。
front-exec:
	docker-compose exec front bash

# Reactプロジェクト新規作成
front-create-app:
	docker-compose exec front sh -c \
		"yarn create vite ${FRONT_PROJ_NAME} --template react-ts"

# front	イメージ削除
front-rmi:
	docker rmi $(shell basename `pwd` | tr 'A-Z' 'a-z')_front

# front volume削除
front-rmvol:
	docker volume rm $(shell basename `pwd` | tr 'A-Z' 'a-z')_front_store

########################################################################################
################################# apiに関するコマンド #####################################
########################################################################################
# apiコンテナ(NestJS)にアクセスする。
api-exec:
	docker-compose exec api bash

# NestJSプロジェクト新規作成
# --skip-installをすることで、プロジェクト作成の際にnode_modulesがインストールされなくなり、Volume-Mountされているnode_modulesと競合せず済む。
# .gitが作られないようにする
api-create-app:
	docker-compose exec api sh -c \
		"nest new ${API_PROJ_NAME} --package-manager yarn --skip-install --skip-git"

# api イメージ削除
api-rmi:
	docker rmi $(shell basename `pwd` | tr 'A-Z' 'a-z')_api

# api volume削除
api-rmvol:
	docker volume rm $(shell basename `pwd` | tr 'A-Z' 'a-z')_api_store

########################################################################################
################################# dbに関するコマンド ######################################
########################################################################################
# dbコンテナのpostgres環境にログインする。コマンドにDBログイン情報を含むが、先頭に@を付けることで表示されなくなる。
db-login:
	@docker-compose exec db sh -c 'psql -U ${DB_USER} -d ${DB_NAME}'

# dbコンテナにアクセスする。
db-exec:
	docker-compose exec db bash

# dbコンテナのvolume(データ保存場所)を削除する。
db-rmvol:
	docker volume rm $(shell basename `pwd` | tr 'A-Z' 'a-z')_db_store
