package main

import (
	"log"
	"net/http"

	"github.com/ricky-davis/bridge/internal/httpapi"
	"github.com/ricky-davis/bridge/internal/web"
)

func main() {
	mux := http.NewServeMux()

	// API
	httpapi.Register(mux)

	// SPA
	dist, err := web.DistFS()
	if err != nil {
		log.Fatalf("failed to load dist fs: %v", err)
	}

	spa := web.SPAHandler(dist)
	mux.Handle("/", spa)

	addr := ":8080"
	log.Printf("listening on http://127.0.0.1%s", addr)
	log.Fatal(http.ListenAndServe(addr, mux))
}
