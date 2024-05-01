#!/bin/bash

# Récupère le nom de l'entité passée en premier argument
ENTITY=$1
ENTITY_CAP=$(echo "$ENTITY" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
ENTITY_LOWER=$(echo "$ENTITY" | awk '{print tolower($0)}')
shift  # décale les arguments pour traiter les champs

# Création des fichiers avec les champs spécifiques dans les structures
# Utilisation d'une boucle directement dans le heredoc

# server/model
echo "package model

import (
    \"gorm.io/gorm\"
)

type $ENTITY_CAP struct {" > server/model/${ENTITY}.go
for field in "$@"
do
    IFS=":" read -ra PARTS <<< "$field"
    FIELD_NAME=${PARTS[0]}
    FIELD_TYPE=${PARTS[1]}
    FIELD_NAME_CAP=$(echo "$FIELD_NAME" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    echo "    $FIELD_NAME_CAP $FIELD_TYPE" >> server/model/${ENTITY}.go
done
echo "}" >> server/model/${ENTITY}.go


# server/port/controller_port
echo "
package controller_port

import \"github.com/gin-gonic/gin\"

type ${ENTITY_CAP}ControllerInterface interface {
    Get${ENTITY}s(c *gin.Context)
    Create${ENTITY}(c *gin.Context)
    Get${ENTITY}ByID(c *gin.Context)
    Delete${ENTITY}ByID(c *gin.Context)
    Update${ENTITY}(c *gin.Context)
}" > server/port/controller_port/${ENTITY_LOWER}ControllerPort.go


# server/port/repository_port
echo "
package repository_port

import (
    \"api/dto\"
    \"api/model\"
)

type ${ENTITY_CAP}RepositoryInterface interface {
    FindAll() ([]model.${ENTITY_CAP}, error)
    FindOneBy(field string, value string) (model.${ENTITY_CAP}, dto.HttpErrorDto)
    Create(user model.${ENTITY_CAP}) (model.${ENTITY_CAP}, dto.HttpErrorDto)
    Delete(id uint64) error
    Update(id uint64, ${ENTITY_LOWER} model.${ENTITY_CAP}) error
}" > server/port/repository_port/${ENTITY_LOWER}RepositoryPort.go


# repository
echo "
package repository

import (
    \"api/dto\"
    \"api/helper\"
    \"api/model\"
    \"api/config\"
    \"gorm.io/gorm\"
    \"strconv\"
    \"fmt\"
)

type ${ENTITY_CAP}Repository struct {
    DB *gorm.DB
}

func (repo *${ENTITY_CAP}Repository) FindAll() []model.${ENTITY_CAP} {
    var ${ENTITY_LOWER}s []model.${ENTITY_CAP}

    result := config.DB.Find(&${ENTITY_LOWER}s)
    helper.ErrorPanic(result.Error)

    return ${ENTITY_LOWER}s
}

func (repo *${ENTITY_CAP}Repository) Create(${ENTITY_LOWER} model.${ENTITY_CAP}) (model.${ENTITY_CAP}, dto.HttpErrorDto) {
    result := config.DB.Create(&${ENTITY_LOWER})
    if result.Error != nil {
        return model.${ENTITY_CAP}{}, dto.HttpErrorDto{Message: \"Error while creating ${ENTITY_LOWER}\", Code: 500}
    }

    return ${ENTITY_LOWER}, dto.HttpErrorDto{}
}

func (repo *${ENTITY_CAP}Repository) FindOneBy(field string, value string) (model.${ENTITY_CAP}, dto.HttpErrorDto) {
    var ${ENTITY_LOWER} model.${ENTITY_CAP}

    result := config.DB.Where(field+\" = ?\", value).First(&${ENTITY_LOWER})
    if result.RowsAffected == 0 {
        return model.${ENTITY_CAP}{}, dto.HttpErrorDto{Message: \"${ENTITY_CAP} not found\", Code: 404}
    }

    if result.Error != nil {
        return model.${ENTITY_CAP}{}, dto.HttpErrorDto{Message: \"Error while fetching ${ENTITY_LOWER}\", Code: 500}
    }

    return ${ENTITY_LOWER}, dto.HttpErrorDto{}
}

func (repo *${ENTITY_CAP}Repository) Delete(id uint64) error {
    result := config.DB.Delete(&model.${ENTITY_CAP}{}, id)
    fmt.Println(\"${ENTITY_CAP}Service\", result)

    if result.Error != nil {
        return result.Error
    }
    if result.RowsAffected == 0 {
        return fmt.Errorf(\"no ${ENTITY_LOWER} found with ID: %d\", id)
    }
    return nil
}

func (repo *${ENTITY_CAP}Repository) Update(id uint64, updated${ENTITY_CAP} model.${ENTITY_CAP}) error {
    existing${ENTITY_CAP}, err := repo.FindOneBy(\"id\", strconv.FormatUint(id, 10))
    if err.Code == 404 {
        return fmt.Errorf(\"${ENTITY_LOWER} not found with ID: %d\", id)
    } else if err.Code != 0 {
        return fmt.Errorf(\"error fetching ${ENTITY_LOWER}: %s\", err.Message)
    }

    result := config.DB.Model(&existing${ENTITY_CAP}).Updates(updated${ENTITY_CAP})
    if result.Error != nil {
        return result.Error
    }

    return nil
}" > server/repository/${ENTITY_LOWER}Repository.go


# server/route
echo "
package route

import (
    \"api/controller\"
    \"api/port/controller_port\"

    \"github.com/gin-gonic/gin\"
)

func ${ENTITY_CAP}Routes(router *gin.Engine) {
    var ${ENTITY_LOWER}ControllerPort controller_port.${ENTITY_CAP}ControllerInterface = &controller.${ENTITY_CAP}Controller{}

    router.GET(\"/${ENTITY_LOWER}s\", ${ENTITY_LOWER}ControllerPort.Get${ENTITY_CAP}s)
    router.POST(\"/add${ENTITY_CAP}\", ${ENTITY_LOWER}ControllerPort.Create${ENTITY_CAP})
    router.GET(\"/${ENTITY_LOWER}/:id\", ${ENTITY_LOWER}ControllerPort.Get${ENTITY_CAP}ByID)
    router.DELETE(\"/${ENTITY_LOWER}/:id\", ${ENTITY_LOWER}ControllerPort.Delete${ENTITY_CAP}ByID)
    router.PATCH(\"/${ENTITY_LOWER}/:id\", ${ENTITY_LOWER}ControllerPort.Update${ENTITY_CAP})
}" > server/route/${ENTITY_LOWER}Route.go


echo "
package service

import (
    \"api/model\"
    \"api/repository\"
    \"api/dto\" 
    \"strconv\"
    \"fmt\"
)

type ${ENTITY_CAP}Service struct {
    ${ENTITY_CAP}Repository repository.${ENTITY_CAP}Repository
}

func (svc *${ENTITY_CAP}Service) FindAll() []model.${ENTITY_CAP} {
    ${ENTITY_LOWER}s := svc.${ENTITY_CAP}Repository.FindAll()

    return ${ENTITY_LOWER}s
}

func (svc *${ENTITY_CAP}Service) Create(${ENTITY_LOWER} model.${ENTITY_CAP}) (model.${ENTITY_CAP}, dto.HttpErrorDto) {
    created${ENTITY_CAP}, err := svc.${ENTITY_CAP}Repository.Create(${ENTITY_LOWER})
    if err.Code != 0 {
        return model.${ENTITY_CAP}{}, err
    }

    return created${ENTITY_CAP}, dto.HttpErrorDto{}
}

func (svc *${ENTITY_CAP}Service) FindByID(id uint64) (model.${ENTITY_CAP}, error) {
    ${ENTITY_LOWER}, err := svc.${ENTITY_CAP}Repository.FindOneBy(\"id\", strconv.FormatUint(id, 10))
    if err.Code != 0 {
        return model.${ENTITY_CAP}{}, fmt.Errorf(\"${ENTITY_LOWER} not found: %s\", err.Message)
    }

    return ${ENTITY_LOWER}, nil
}

func (svc *${ENTITY_CAP}Service) Delete(id uint64) error {
    _, findErr := svc.${ENTITY_CAP}Repository.FindOneBy(\"id\", strconv.FormatUint(id, 10))

    if findErr.Code == 404 {
        return fmt.Errorf(\"${ENTITY_LOWER} not found with ID: %d\", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf(\"error fetching ${ENTITY_LOWER}: %s\", findErr.Message)
    }

    deleteErr := svc.${ENTITY_CAP}Repository.Delete(id)
    fmt.Println(\"${ENTITY_CAP}Service\", deleteErr)

    if deleteErr != nil {
        return fmt.Errorf(\"error deleting ${ENTITY_LOWER}: %s\", deleteErr.Error())
    }
    return nil
}

func (svc *${ENTITY_CAP}Service) Update(id uint64, updated${ENTITY_CAP} model.${ENTITY_CAP}) error {
    _, findErr := svc.${ENTITY_CAP}Repository.FindOneBy(\"id\", strconv.FormatUint(id, 10))
    if findErr.Code == 404 {
        return fmt.Errorf(\"${ENTITY_LOWER} not found with ID: %d\", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf(\"error fetching ${ENTITY_LOWER}: %s\", findErr.Message)
    }

    updateErr := svc.${ENTITY_CAP}Repository.Update(id, updated${ENTITY_CAP})
    if updateErr != nil {
        return fmt.Errorf(\"error updating ${ENTITY_LOWER}: %s\", updateErr.Error())
    }

    return nil
}" > server/service/${ENTITY_LOWER}Service.go


# controller
echo "// ${ENTITY_LOWER}Name: $ENTITY_LOWER
package controller

import (
    _ \"api/docs\"
    \"net/http\"
    \"api/service\"
    \"api/model\"
    \"strconv\"
    \"github.com/gin-gonic/gin\"
    \"strings\"
)

type ${ENTITY_CAP}Controller struct {
    ${ENTITY_CAP}Service service.${ENTITY_CAP}Service
}

func (ctrl *${ENTITY_CAP}Controller) Get${ENTITY_CAP}s(ctx *gin.Context) {
    ${ENTITY_LOWER}s := ctrl.${ENTITY_CAP}Service.FindAll()
    ctx.Header(\"Content-Type\", \"application/json\")
    ctx.JSON(http.StatusOK, ${ENTITY_LOWER}s)
}

func (ctrl *${ENTITY_CAP}Controller) Create${ENTITY_CAP}(ctx *gin.Context) {
    var ${ENTITY_LOWER} model.${ENTITY_CAP}
    if err := ctx.ShouldBindJSON(&${ENTITY_LOWER}); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{\"error\": err.Error()})
        return
    }
    created${ENTITY_CAP}, err := ctrl.${ENTITY_CAP}Service.Create(${ENTITY_LOWER})
    if err.Code != 0 {
        ctx.JSON(err.Code, gin.H{\"message\": err.Message})
        return
    }
    ctx.JSON(http.StatusCreated, created${ENTITY_CAP})
}

func (ctrl *${ENTITY_CAP}Controller) Get${ENTITY_CAP}ByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param(\"id\"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{\"error\": \"Invalid ${ENTITY_LOWER} ID\"})
        return
    }
    ${ENTITY_LOWER}, err := ctrl.${ENTITY_CAP}Service.FindByID(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{\"error\": \"Internal server error\"})
        return
    }
    ctx.JSON(http.StatusOK, ${ENTITY_LOWER})
}

func (ctrl *${ENTITY_CAP}Controller) Delete${ENTITY_CAP}ByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param(\"id\"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{\"error\": \"Invalid ${ENTITY_LOWER} ID\"})
        return
    }
    err = ctrl.${ENTITY_CAP}Service.Delete(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{\"error\": \"Internal server error\"})
        return
    }
    ctx.Status(http.StatusNoContent)
}

func (ctrl *${ENTITY_CAP}Controller) Update${ENTITY_CAP}(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param(\"id\"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{\"error\": \"Invalid ${ENTITY_LOWER} ID\"})
        return
    }
    var updated${ENTITY_CAP} model.${ENTITY_CAP}
    if err := ctx.ShouldBindJSON(&updated${ENTITY_CAP}); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{\"error\": \"Invalid request body\"})
        return
    }
    err = ctrl.${ENTITY_CAP}Service.Update(id, updated${ENTITY_CAP})
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{\"error\": \"Internal server error\"})
        return
    }
    ctx.Status(http.StatusNoContent)
}" > server/controller/${ENTITY_LOWER}Controller.go

echo "Files for ${ENTITY_LOWER} created successfully."