package httpapi

import (
	"encoding/json"
	"net/http"
)

type Health struct {
	OK bool `json:"ok"`
}

func Register(mux *http.ServeMux) {
	mux.HandleFunc("GET /api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(Health{OK: true})
	})
}
