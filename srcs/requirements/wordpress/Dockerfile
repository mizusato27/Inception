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

# PHP-FPMを動作させるために必要なディレクトリ作成
RUN mkdir -p /run/php

# 起動コマンド (仮)
# ※ 後ほど起動スクリプト(entrypoint)に変更しますが、まずはフォアグラウンド起動で設定
CMD ["/usr/sbin/php-fpm7.4", "-F"]
