# Etapa 1: compilação
FROM golang:1.21-bookworm AS builder

WORKDIR /app

# Copiar dependências primeiro para aproveitar o cache
COPY go.mod go.sum ./

RUN go mod download

# Copiar código-fonte
COPY . .

# Compilar binário Linux
RUN CGO_ENABLED=0 GOOS=linux go build -o /auth-service .

# Etapa 2: imagem final
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /auth-service /app/auth-service

ENV PORT=8001

EXPOSE 8001

CMD ["/app/auth-service"]
