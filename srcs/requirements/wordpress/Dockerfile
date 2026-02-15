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

# PHP-FPMの設定ファイルを上書き
# デフォルトの設定(/etc/php/7.4/fpm/pool.d/www.conf)をカスタム設定で置換
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# 起動スクリプトをコピーし、実行権限を付与
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# PHP-FPM用ディレクトリ作成
RUN mkdir -p /run/php

# 作業ディレクトリの設定
WORKDIR /var/www/html

# ENTRYPOINT でスクリプトを実行する
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
