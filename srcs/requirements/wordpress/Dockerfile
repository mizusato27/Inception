# ベースイメージ
FROM debian:bullseye

# 必要なパッケージのインストール
# - php-fpm: PHPの実行エンジン (FastCGI)
# - php-mysql: WordPressがMariaDBと通信するためのドライバ
# - mariadb-client: データベース接続確認用コマンド
# - wget/curl: WordPress本体やWP-CLIのダウンロードに使用
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# WP-CLI のインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 設定ファイルとスクリプトの配置
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# PHP-FPM用ディレクトリ作成
RUN mkdir -p /run/php

# 作業ディレクトリの設定
WORKDIR /var/www/html

# ENTRYPOINT でスクリプトを実行する
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
