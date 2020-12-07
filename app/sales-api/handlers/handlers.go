// Package handlers contains the full set of handler functions and routes supported by the web api.
package handlers

import (
	"log"
	"net/http"
	"os"

	"github.com/petersveter108/sales-service/business/auth"
	"github.com/petersveter108/sales-service/business/mid"
	"github.com/petersveter108/sales-service/foundation/web"
)

// API constructs a http.Handler with all application routes defined.
func API(build string, shutdown chan os.Signal, log *log.Logger, a *auth.Auth) *web.App {

	// Construct the web.App which holds all routes as well as common Middleware.
	app := web.NewApp(shutdown, mid.Logger(log), mid.Errors(log), mid.Metrics(), mid.Panics(log))

	check := check{
		log: log,
	}

	app.Handle(http.MethodGet, "/readiness", check.readiness, mid.Authenticate(a), mid.Authorize(auth.RoleAdmin))

	return app
}
