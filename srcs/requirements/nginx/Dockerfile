# ベースイメージ: Debian の "Penultimate Stable" (Bullseye) を使用
FROM debian:bullseye

# パッケージリストの更新とインストール、およびキャッシュの即時削除
# - nginx: Webサーバー本体
# - openssl: SSL証明書(https用)を作るためのツール
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# SSL証明書を保存するディレクトリを作成
RUN mkdir -p /etc/nginx/ssl

# 設定ファイルをコンテナ内にコピー
COPY conf/nginx.conf /etc/nginx/nginx.conf

# -----------------------------------------------------------------------------
# 権限とディレクトリの設定
# -----------------------------------------------------------------------------
# NGINXのプロセスが実行時にPIDファイル（プロセスIDを記録するファイル）などを
# 生成・配置するためのディレクトリをあらかじめ作成。
RUN mkdir -p /var/run/nginx

# Webコンテンツ（WordPressのファイル等）が配置されるドキュメントルートの
# パーミッションを 755 (所有者は読み書き実行可、他は読み取りと実行のみ可) に設定。
RUN chmod 755 /var/www/html

# NGINXのワーカープロセスはデフォルトで 'www-data' ユーザーとして動作する。
# このユーザーがドキュメントルート内のファイルを正常に読み取れるように、
# ディレクトリと配下のファイルの所有者およびグループを 'www-data' に変更する。
RUN chown -R www-data:www-data /var/www/html

# 起動スクリプトのコピーと実行権限の付与
COPY tools/nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx.sh

# スクリプトを実行
ENTRYPOINT ["/usr/local/bin/nginx.sh"]
