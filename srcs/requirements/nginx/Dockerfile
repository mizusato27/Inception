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
    -subj "/C=JP/ST=Tokyo/L=Inception/O=42/OU=42/CN=mizusato.42.fr/UID=mizusato"

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

# -----------------------------------------------------------------------------
# コンテナの起動コマンド
# -----------------------------------------------------------------------------
# NGINXをバックグラウンド（デーモン）ではなく、フォアグラウンドプロセスとして起動する。
# DockerコンテナはPID 1のプロセスが終了するとコンテナ自体も停止してしまうため、
# 'daemon off;' を指定することでプロセスをブロックし続け、コンテナの稼働を維持する。
# ※ tail -f や sleep などの無限ループコマンドでコンテナを維持することは禁じられている
CMD ["nginx", "-g", "daemon off;"]
