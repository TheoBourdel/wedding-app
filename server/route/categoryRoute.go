package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/middelware"

	"github.com/gin-gonic/gin"
)

func CategoryRoutes(router *gin.Engine) {
	var categoryControllerPort controller_port.CategoryControllerInterface = &controller.CategoryController{}
	
	router.POST("/addcategory",middelware.RequireAuthAndAdmin, categoryControllerPort.CreateCategory)
	router.DELETE("/category/:id",middelware.RequireAuthAndAdmin, categoryControllerPort.DeleteCategoryByID)
	router.PATCH("/category/:id",middelware.RequireAuthAndAdmin, categoryControllerPort.UpdateCategory)

	router.GET("/categorys",middelware.RequireAuth, categoryControllerPort.GetCategorys)
	router.GET("/category/:id", middelware.RequireAuth,categoryControllerPort.GetCategoryByID)




}
