package admin

import (
	"github.com/gin-gonic/gin"
	"github.com/krmall/krmall/cmd/core"
	"github.com/spf13/cobra"
	"github.com/unisx/logus"
	"net/http"
	"time"
)

var (
	address     string
	certFile    string
	keyFile     string
	enableHttps bool
	inDebug     bool
)

func init() {
	adminCmd := &cobra.Command{
		Use:   "admin",
		Short: "Start to KrMall admin ui service",
		Long:  "Start to KrMall admin ui service",
		Run:   adminRun,
	}

	// Parse flags for serveCmd
	adminCmd.Flags().StringVarP(&address, "addr", "a", ":3000", "service listen address")
	adminCmd.Flags().StringVarP(&certFile, "cert", "e", "", "certificate path used in https connect")
	adminCmd.Flags().StringVarP(&keyFile, "key", "k", "", "key path used in https connect")
	adminCmd.Flags().BoolVarP(&enableHttps, "https", "s", false, "whether use https serve connect")
	adminCmd.Flags().BoolVarP(&inDebug, "debug", "d", false, "whether in debug mode")

	// Register adminCmd as sub-command
	core.Register(adminCmd)
}

func adminRun(cmd *cobra.Command, args []string) {
	setup()

	// Setup http.Server
	server := &http.Server{
		Handler: newPortal(),
		Addr:    address,
		// Good practice: enforce timeouts for servers you create!
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	// Start http.Server
	var err error
	logus.Info("listen and serve", logus.String("address", address))
	if enableHttps {
		err = server.ListenAndServeTLS(certFile, keyFile)
	} else {
		err = server.ListenAndServe()
	}
	if err != nil {
		logus.E("listen and serve error", err)
	}
}

// setup pre setup before start serve
func setup() {
	if !inDebug {
		logus.InProduction()
		gin.SetMode(gin.ReleaseMode)
	}
}
