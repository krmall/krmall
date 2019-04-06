package main

import (
	"github.com/krmall/krmall/cmd/core"
	"github.com/unisx/logus"

	_ "github.com/krmall/krmall/cmd/admin"
	_ "github.com/krmall/krmall/cmd/backup"
	_ "github.com/krmall/krmall/cmd/serve"
	_ "github.com/krmall/krmall/cmd/version"
)

func main() {
	defer logus.Sync()

	// Setup root cli command of application
	core.Setup(
		"krmall",                 // command name
		"Provide KrMall service", // command short describe
		"Provide KrMall service", // command long describe
	)

	// Execute start application
	core.Execute()
}
