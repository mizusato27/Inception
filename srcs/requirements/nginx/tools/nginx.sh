#!/bin/bash

# SSL証明書の発行
# - x509: 証明書の規格
# - nodes: パスワード入力をスキップ
# - days 365: 有効期限
# - newkey rsa:2048: 暗号化方式
# - keyout: 鍵の保存場所
# - out: 証明書の保存場所
# - subj: 所有者情報 (国=JP, 組織=42, 共通名=login.42.fr など)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=JP/ST=Tokyo/L=Inception/O=42/OU=42/CN=${DOMAIN_NAME}/UID=${LOGIN}"

# nginx.conf のプレースホルダーを実際の環境変数に置換する
sed -i "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

# NGINXをバックグラウンド（デーモン）ではなく、フォアグラウンドプロセスとして起動する。
# DockerコンテナはPID 1のプロセスが終了するとコンテナ自体も停止してしまうため、
# 'daemon off;' を指定することでプロセスをブロックし続け、コンテナの稼働を維持する。
# ※ tail -f や sleep などの無限ループコマンドでコンテナを維持することは禁じられている
exec nginx -g 'daemon off;'
