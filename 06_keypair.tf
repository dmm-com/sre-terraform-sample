# 事前に公開鍵を下記のディレクトリに配置してください
resource "aws_key_pair" "auth" {
  key_name   = "keypair"
  public_key = file(".ssh/id_rsa.pub")
}