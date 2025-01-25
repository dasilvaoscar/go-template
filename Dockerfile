# Etapa 1: Build
FROM golang:1.23.5-alpine3.21 as builder

# Instalar dependências necessárias
RUN apk add --no-cache git

# Diretório de trabalho
WORKDIR /app

# Copiar go.mod e go.sum para resolver as dependências
COPY go.mod go.sum ./

# Baixar dependências
RUN go mod tidy

# Copiar o código da aplicação
COPY . .

# Compilar o binário com flags para otimizar o tamanho
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -extldflags '-static'" -o app .

# Etapa 2: Imagem de produção
FROM alpine:latest

# Diretório de trabalho
WORKDIR /root/

# Copiar o binário compilado da etapa de build
COPY --from=builder /app/app .

# Expor a porta que a aplicação vai usar
EXPOSE 8080

# Comando para rodar a aplicação
CMD ["./app"]
