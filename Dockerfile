FROM golang:1.23.5-alpine3.21 as builder

RUN apk add --no-cache git

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod tidy

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -extldflags '-static'" -o app .

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
