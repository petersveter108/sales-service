// Package handlers contains the full set of handler functions and routes supported by the web api.
package handlers

import (
	"github.com/petersveter108/sales-service/business/mid"
	"log"
	"net/http"
	"os"

	"github.com/petersveter108/sales-service/foundation/web"
)

// API constructs a http.Handler with all application routes defined.
func API(build string, shutdown chan os.Signal, log *log.Logger) *web.App {
	app := web.NewApp(shutdown, mid.Logger(log))

	check := check{
		log: log,
	}

	app.Handle(http.MethodGet, "/readiness", check.readiness)

	return app
}
