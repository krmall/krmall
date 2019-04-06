package admin

import (
	"github.com/krmall/krmall-admin/portal"
	"net/http"
)

func newPortal() http.Handler {
	return http.FileServer(portal.AssetFile())
}
