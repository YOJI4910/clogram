# 基にするイメージ
FROM ruby:2.5.7

ENV LANG C.UTF-8

# RUN: docker buildする時に実行される. imageの中で実行するshellコマンド
# 必要なパッケージのインストール(基本的)
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# 作業ディレクトリの作成、設定
RUN mkdir /app_name

## 作業ディレクトリ名をAPP_ROOTに割り当てて、以下$APP_ROOTで参照
# コンテナ起動時の作業ディレクトリの中で指定. 
# WORKDIR: 起点となるディレクトリを設定 相対パスを使うときに起点になる
ENV APP_ROOT /app_name
WORKDIR $APP_ROOT

# COPY: ローカルファイルをコンテナへコピー(ホスト→コンテナ)
# ADD: ファイル、ディレクトリなどをコンテナの指定されたパスにコピー
# ホスト側（ローカル）のGemfileを追加する
COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
COPY . $APP_ROOT

# docker-compose up: dockerfileを基にコンテナの作成と開始
# docker exec -it todo_app_1 /bin/bash: dockerの中に入る

# $ docker-compose run web rails new . --force --database=mysql --skip-bundle
# 後で再度ビルドを行う必要がある為、--skip-bundleでビルドをスキップする。
# すでにGemfileがあるためforce(上書き）オプション付き

# docker-composeでGemfileが更新されたらビルドする
# $ docker-compose build

# GemfileはRailsをインストールするために、ここで作成していますが、
# あとでrails newを実行した時に上書きされます。