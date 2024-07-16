package controller_port

import "github.com/gin-gonic/gin"

type LogControllerInterface interface {
    GetAllLogs(c *gin.Context)
    CreateLog(c *gin.Context)
}
