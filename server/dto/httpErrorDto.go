package dto

type HttpErrorDto struct {
	Message string
	Code    int
}

func (e HttpErrorDto) Error() string {
	return e.Message
}