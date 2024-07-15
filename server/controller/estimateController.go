package controller

import (
	_ "api/docs"
	"api/dto"
	"api/model"
	"api/repository"
	"api/service"
	"context"
	"net/http"
	"strconv"

	"github.com/braintree-go/braintree-go"
	"github.com/gin-gonic/gin"
)

var braintreeClient = braintree.New(
	braintree.Sandbox,
	"qsn76kgd9qtrkyv5",
	"bkjgqjkth8hwmbtr",
	"ad17c621a06251c4f5c40a61adf50980",
)

type EstimateController struct {
	EstimateService    service.EstimateService
	CategoryRepository repository.CategoryRepository
	UserRepository     repository.UserRepository
	WeddingRepository  repository.WeddingRepository
}

func (ec *EstimateController) UpdateEstimate(ctx *gin.Context) {
	userId, _ := strconv.Atoi(ctx.Param("userId"))
	estimateId, _ := strconv.Atoi(ctx.Param("estimateId"))

	var body model.Estimate
	if err := ctx.Bind(&body); err != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request body"})
		return
	}

	estimate, error := ec.EstimateService.UpdateEstimate(userId, estimateId, body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(200, estimate)
}

func (ec *EstimateController) DeleteEstimate(ctx *gin.Context) {
	userId, _ := strconv.Atoi(ctx.Param("userId"))
	estimateId, _ := strconv.Atoi(ctx.Param("estimateId"))

	error := ec.EstimateService.DeleteEstimate(userId, estimateId)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(204, nil)
}

func (ec *EstimateController) PayEstimate(ctx *gin.Context) {
	var request struct {
		EstimateID uint   `json:"estimate_id"`
		Nonce      string `json:"nonce"`
	}
	if err := ctx.ShouldBindJSON(&request); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	estimate, err := ec.EstimateService.GetEstimateByID(request.EstimateID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	amount := estimate.Price

	tx, braintreeErr := braintreeClient.Transaction().Create(context.Background(), &braintree.TransactionRequest{
		Type:               "sale",
		Amount:             braintree.NewDecimal(int64(amount*100), 2),
		PaymentMethodNonce: request.Nonce,
		Options: &braintree.TransactionOptions{
			SubmitForSettlement: true,
		},
	})
	if braintreeErr != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": braintreeErr.Error()})
		return
	}

	category, err := ec.CategoryRepository.FindOneBy("id", strconv.Itoa(int(estimate.Service.CategoryID)))
	if err != (dto.HttpErrorDto{}) {
		return
	}

	if category.Name == "Organisateur" {

		provider, err := ec.UserRepository.FindOneBy("id", strconv.Itoa(int(estimate.ProviderID)))
		if err != (dto.HttpErrorDto{}) {
			return
		}

		client, err := ec.UserRepository.FindOneBy("id", strconv.Itoa(int(estimate.ClientID)))
		if err != (dto.HttpErrorDto{}) {
			return
		}

		wedding, err := ec.WeddingRepository.FindOneBy("id", strconv.Itoa(int(client.Weddings[0].ID)))
		if err != (dto.HttpErrorDto{}) {
			return
		}

		//provider.Weddings = append(provider.Weddings, wedding)
		// ADD PROVIDER TO WEDDING ORGANIZERS

		provider.Weddings = append(provider.Weddings, wedding)

		provider, err = ec.UserRepository.Update(provider)
		if err != (dto.HttpErrorDto{}) {
			ctx.JSON(http.StatusInternalServerError, err)
			return
		}
	}

	ctx.JSON(http.StatusOK, tx)
}
