package openapi

import (
        "fmt"
        "gorm.io/driver/mysql"
        "gorm.io/gorm"
        "github.com/kelseyhightower/envconfig"
        "errors"
)

type Env struct {
    DBUser string
    DBPass string
    DBProtocol string
    DBName string
}

// Connect DB
func SqlConnect() (e error) {
    var goenv Env
    envconfig.Process("api", &goenv)
    
    CONNECT := goenv.DBUser + ":" + goenv.DBPass + "@" + goenv.DBProtocol + "/" + goenv.DBName + "?charset=utf8&parseTime=true&loc=Asia%2FTokyo"
    fmt.Println(CONNECT)
    _, err := gorm.Open(mysql.Open(CONNECT), &gorm.Config{})
    if err != nil {
      fmt.Println(err.Error())
      return errors.New("DB接続失敗")
    } else {
      fmt.Println("DB接続成功") 
      return
    }
}
