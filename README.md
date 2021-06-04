# ルール
* case1_system.png　をみて同等構成をTerraformのコードで作成してください。
* ただしVPC,Subnet,NatGateWay,InternatGatewayはコンソールで作成してもIaCでもどちらでも構いません（自分の理解度、チャレンジ意欲で判断してください。後からIaC化もあり）

# 本研修を実施する前に行うこと
## .sshの設置
ご自身の公開鍵を事前にプロジェクトディレクトリの以下に配置してください。
.ssh/id_rsa.pub

# 作成順序(一例)
* vpc(data)
* subnet(data)
* natgateway
* internetgateway
* rute_table
* security_group
* ami(data)
* keypair(ec2へ)
* ec2/eip
* alb
* rds

# サンプルコードをご利用になる方へ
* VPCにvpcというNameを設定してください
* パブリックサブネットにpublic-aやpublic-bといったNameを設定してください
* プライベートサブネットにprivate-aやprivate-bといったNameを設定してください
* サンプルコードはnatgatewayを作成しています

Terraformから参照可能になるように利用するVPCに対してNameを設定してください
# EC2サーバにSSHしたい方

`~/.ssh/config`に以下の記述を行いSSHでログインすることができます

```
Host bastion
  HostName <踏み台サーバのパブリックIP>
  User ec2-user
  IdentityFile ~/.ssh/id_rsa
  StrictHostKeyChecking no
  IdentitiesOnly yes

Host web1
  HostName <webサーバ#1のパブリックIP>
  User ec2-user
  ProxyCommand ssh -W %h:%p bastion
  StrictHostKeyChecking no
  IdentitiesOnly yes

Host web2
  HostName <webサーバ#2のパブリックIP>
  User ec2-user
  ProxyCommand ssh -W %h:%p bastion
  StrictHostKeyChecking no
  IdentitiesOnly yes
```

* 接続方法
```
ssh web1
または
ssh web2
```
