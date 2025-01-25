package utils

import "os"

func IsDev() bool {
	return os.Getenv("ENV") == "develop"
}
