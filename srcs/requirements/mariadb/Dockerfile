# ベースイメージ: Debian Bullseye
FROM debian:bullseye

# MariaDB サーバーのインストール
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# 設定ファイルをコピー
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# 起動スクリプトをコピーして実行権限を付与
COPY tools/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

# 必要なディレクトリの作成と権限設定
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# コンテナ起動時にスクリプトを実行
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
