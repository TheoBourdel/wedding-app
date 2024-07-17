package model


type PaymentSettings struct {
    ID               uint `gorm:"primaryKey"`
    IsPaymentEnabled bool `json:"is_payment_enabled"`
}
