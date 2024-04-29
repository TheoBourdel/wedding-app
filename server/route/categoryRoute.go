package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func CategoryRoutes(router *gin.Engine) {
	var categoryControllerPort controller_port.CategoryControllerInterface = &controller.CategoryController{}

	router.GET("/categorys", categoryControllerPort.GetCategorys)
	router.POST("/addcategory", categoryControllerPort.CreateCategory)
	router.GET("/category/:id", categoryControllerPort.GetCategoryByID)
	router.DELETE("/category/:id", categoryControllerPort.DeleteCategoryByID)
	router.PATCH("/category/:id", categoryControllerPort.UpdateCategory)




}
