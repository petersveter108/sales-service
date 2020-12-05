package middleware

import (
	"context"
	"github.com/petersveter108/sales-service/foundation/web"
	"net/http"
)

// Logger...
func Logger(before web.Handler) web.Handler {

	h := func(ctx context.Context, w http.ResponseWriter, r *http.Request) error {
		err := before(ctx, w, r)

		// BOILERPLATE - LOGGING

		return err
	}

	return h
}
