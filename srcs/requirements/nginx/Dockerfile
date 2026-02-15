# ベースイメージ: Debian の "Penultimate Stable" (Bullseye) を使用
FROM debian:bullseye

# パッケージリストの更新とインストール
# - nginx: Webサーバー本体
# - openssl: SSL証明書(https用)を作るためのツール
RUN apt-get update && apt-get install -y nginx openssl

# SSL証明書を保存するディレクトリを作成
RUN mkdir -p /etc/nginx/ssl

# SSL証明書の発行
# - x509: 証明書の規格
# - nodes: パスワード入力をスキップ
# - days 365: 有効期限
# - newkey rsa:2048: 暗号化方式
# - keyout: 鍵の保存場所
# - out: 証明書の保存場所
# - subj: 所有者情報 (国=JP, 組織=42, 共通名=login.42.fr など)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=JP/ST=Tokyo/L=Inception/O=42/OU=42/CN=login.42.fr/UID=login"

# 設定ファイルをコンテナ内にコピー (この後作ります)
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 権限設定 (Web公開用ディレクトリの所有権をnginxユーザーへ)
RUN mkdir -p /var/run/nginx
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# NGINX をフォアグラウンドで実行
CMD ["nginx", "-g", "daemon off;"]
