package main

import (
	"go-service/cmd/utils"
	"log"
)

func main() {
	log.Println("Env:", utils.IsDev())
}
