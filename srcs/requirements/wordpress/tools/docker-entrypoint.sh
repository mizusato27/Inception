#!/bin/bash

# 作業ディレクトリへの移動
cd /var/www/html

# WP-CLI のインストール（存在しない場合のみ）
if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# WordPress が未インストール（wp-config.php がない）場合のみセットアップを実行
if [ ! -f "wp-config.php" ]; then
    # WordPress 本体のダウンロード
    wp core download --allow-root

    # 設定ファイル (wp-config.php) の作成
    # データベースのホスト名は "mariadb" (コンテナ名) を指定
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    # WordPress のインストール（管理者ユーザーの作成）
    wp core install \
        --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --allow-root

    # 一般ユーザーの作成（課題要件: 2人のユーザーが必要）
    wp user create \
        $USER1_NAME \
        $USER1_EMAIL \
        --user_pass=$USER1_PASS \
        --role=author \
        --allow-root
fi

# PHP-FPM の起動（PID 1 として置き換える）
exec /usr/sbin/php-fpm7.4 -F
