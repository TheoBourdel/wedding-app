FROM golang:1.22.1

WORKDIR /app

RUN mkdir "/build"

COPY go.mod .
# COPY go.sum .

RUN go mod download

COPY . .

RUN go get github.com/githubnemo/CompileDaemon
RUN go install github.com/githubnemo/CompileDaemon

ENTRYPOINT CompileDaemon -build="go build -o /build/app" -command="/build/app"