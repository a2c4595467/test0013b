# MySQL8.0 のリードレプリカを作成する

## 目的

これはdocker-compose を使ってMySQL8のレプリケーションを学習するためのものです。  
(グループレプリケーションではないです)
<br>


## 参考URL
### ※MySQL5.7 と 8.0 では仕様変更があるので、参考URL先をそのままコピーできないので注意すること。

<br>

DockerでMySQLのリードレプリカを作成する  
https://www.seeds-std.co.jp/blog/creators/2020-12-17-145757/

<br>


docker-compose で MySQL レプリケーション環境をサクッと用意する
https://ngyuki.hatenablog.com/entry/2019/02/18/103036

<br>


docker-compose MySQL8.0 のDBコンテナを作成する
https://qiita.com/ucan-lab/items/b094dbfc12ac1cbee8cb

<br>

---

## ■対応

<br>

### ディレクトリ構成

```
.
├ docker-compose.yml
├ environment.env
├ master
│ ├ Dockerfile
│ ├ etc
│ │ └ mysql
│ │   └ mysql_master.cnf
│ ├ init_data
│ │ └ 001-GRANT_REPLICATION.sh
│ └ log
├ README.md
└ slave
  ├ Dockerfile
  ├ etc
  │ └ mysql
  │   └ mysql_slave.cnf
  ├ init_data
  │ └ 001-START_REPLICA.sh
  └ log
```

<br>

### ●起動のエラー
```
mysqld: [Warning] World-writable config file '/etc/mysql/conf.d/mysql_read.cnf' is ignored.   

mysqld: [Warning] World-writable config file '/etc/mysql/conf.d/mysql_source.cnf' is ignored.
```
↓↓  
ネットでは、ホスト側でファイルをリードオンリーにするとDocker側で動くと説明する記事があったが、動かない。
実際は、Dockerfile内に COPY を使ってコンテナ内へコピーする必要がある。

```
FROM mysql:8.0.23

COPY ./master/etc/mysql/mysql_master.cnf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf
RUN mkdir /var/lib/mysql-files
```

### ●entrypointのシェルスクリプトファイル

今回はマスターに[001-GRANT_REPLICATION.sh]、スレイブに  
[001-START_REPLICA.sh]を
用意しているが、拡張子は小文字にしておかないと実行されない。
また、有効な拡張子は「.sh」「.sql」「.sql.gz」

・参考URL
Docker MySQLコンテナ起動時に初期データを投入する
https://qiita.com/NagaokaKenichi/items/ae037963b33a85df33f5


### ●MySQLのレプリケーションユーザー作成

・master, slave共に bind-addressを0.0.0.0として、dockerのネットワークエイリアスで繋ぐ
・masterのMySQLにレプリケーション用のユーザーを作成するが、MySQL8.0ではGRANT構文での
　ユーザを作成できない

create user 'slave_user'@'%' identified by 'password';
grant replication slave on *.* to 'slave_user'@'%' with grant option;
flush privileges;


・参考URL
MySQLのmaster slave構成をDockerで試す
https://raahii.github.io/posts/docker-mysql-master-slave-replication/

<br>

---

### ●MySQL8.0のレプリケーションについて

**5.7と8.0では変更されている箇所が多い。**

```
error connecting to master 'repl_user@192.168.56.34:3306' - retry-time: 60 
retries: 1 
message: Authentication plugin 'caching_sha2_password' reported 
error: Authentication requires secure connection.
```

MySQL8から「caching_sha2_password」認証プラグインがデフォルトになった。  
「安全な接続」または「RSAベースのパスワード交換」を使用することが公式リファレンスマニュアル上で随所に記載がある。

- レプリケーション用ユーザーの認証プラグインをmysql_native_password にする。

- レプリケーション用ユーザーの認証プラグインを caching_sha2_password のままとし、「安全な接続」または「RSAベースのパスワード交換」で接続する。
<br><br>

「安全な接続」はmaster/slaveにSSL証明書を作成する必要がある。  
今回は、「RSAベースのパスワード交換」を行う

記述
```
    MASTER_SSL = 1,
    GET_MASTER_PUBLIC_KEY = 1; \
```

・参考URL  
MySQL8.0で新たに追加されているレプリケーション接続オプション
https://blog.s-style.co.jp/2020/03/5861/

ＭｙＳＱＬ８．０のインストールと初期セットアップ
https://qiita.com/nanorkyo/items/94a80683c6753f61316a#fn7

<br>

---

### ●コンテナの日本語対応

MySQLコンテナは基本的にロケール設定はないので、Dockerfile にてロケール設定を行う。

```
RUN apt-get update && \
    apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN { \
    echo '[mysqld]'; \
    echo 'character-set-server=utf8mb4'; \
    echo 'collation-server=utf8mb4_general_ci'; \
    echo '[client]'; \
    echo 'default-character-set=utf8mb4'; \
} > /etc/mysql/conf.d/charset.cnf
```

参考URL  
MacでDocker上に日本語環境のMySQL8.0を建てる
https://qiita.com/oono_yoshi/items/4c9c2ea554b5626ff50c

<br>

---

## ■dbeaverでDB接続

ホストOS上のdbeaverからコンテナのMySQLへ接続する際に「Publick Key Retrieval is not allowed」エラーが表示される。

接続先プロファイルのドライバー設定から「allowPublicKeyRetrieval」をtrueにする必要がある。

<br>

---

## ■コンテナへ入るコマンド

### ●マスター
```
$ docker exec -it db_master bash
```

### ●スレーブ
```
$ docker exec -it db_slave bash
```
