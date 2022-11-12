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

# 環境の全リセット
all-reset:
	@make front-rmi
	@make api-rmi
	@make front-rmvol
	@make api-rmvol
	@make db-rmvol

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

# Next.jsプロジェクト新規作成
# (1)/workspace/front(ホスト側の./front)のプロジェクト内のnode_modulesがVolume-Mountがされている関係上、
# 	一時的にコンテナ内の/workspace_tmpにプロジェクトを作成、
# (2)/workspace_tmpに作成したプロジェクトのファイルを、/workspace/frontのプロジェクトに移動させるが、
# 	node_modules, .gitの移動は行いたくないので、移動前に削除。
# (3)/workspace_tmpのプロジェクトから残ったファイルを/workspace/frontに移動。
# (4)/workspace_tmpを削除
# front-create-app:
# 	docker-compose exec front sh -c \
# 		"mkdir /workspace_tmp && cd /workspace_tmp && yarn create next-app --ts ${FRONT_PROJ_NAME} && \
# 		cd ./${FRONT_PROJ_NAME} && rm -rf .git node_modules &&\
# 		cd /workspace_tmp/${FRONT_PROJ_NAME} && mv * .[^\.]* /workspace/front/${FRONT_PROJ_NAME} && \
# 		cd /workspace/front && rm -rf /workspace_tmp"

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
