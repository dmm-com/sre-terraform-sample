# Go API Server for openapi

This is sample.

## Overview
openapi-generatorで初期構築しています。

[README](https://openapi-generator.tech)


### Running the server

環境変数にDB接続情報を設定してください
```
export API_DBUSER=admin
export API_DBPASS=aaa
export API_DBNAME=hello
export API_DBPROTOCOL="tcp(zzzzzz.yyyy.ap-northeast-1.rds.amazonaws.com:3306)"
```


```
go run main.go
```

docker container
```
docker build --network=host -t openapi .
```

image built
```
docker run --rm -it openapi
```
