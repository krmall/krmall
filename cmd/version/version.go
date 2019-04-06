package version

import (
	"fmt"
	"github.com/krmall/krmall/cmd/core"
	"github.com/spf13/cobra"

	appVer "github.com/krmall/krmall/version"
)

func init() {
	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Version of application",
		Long:  "Version information for application",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("%s (ApiVersion:%s)\nBuildTime:%s\nGitHash:%s\n",
				appVer.Version, appVer.ApiVersion, appVer.BuildTime, appVer.GitHash)
		},
	}

	// Register versionCmd as sub-command
	core.Register(versionCmd)
}
