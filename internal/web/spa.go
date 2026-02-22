package web

import (
	"io/fs"
	"net/http"
	"path"
	"strings"
)

// SPAHandler serves a Vite-built single-page app from dist.
//
// - Static assets are served normally.
// - Unknown paths fall back to index.html (client-side routing).
//
// Assumption: dist contains index.html (i.e., frontend was built).
func SPAHandler(dist fs.FS) http.Handler {
	fileServer := http.FileServer(http.FS(dist))

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		indexBytes, err := fs.ReadFile(dist, "index.html")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		p := r.URL.Path
		if p == "" {
			p = "/"
		}

		clean := path.Clean(p)
		if strings.Contains(clean, "..") {
			http.Error(w, "bad path", http.StatusBadRequest)
			return
		}

		// If the request has a file extension, let the file server handle it.
		// Otherwise, fall back to SPA index.html.
		if strings.Contains(path.Base(clean), ".") {
			fileServer.ServeHTTP(w, r)
			return
		}

		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_, _ = w.Write(indexBytes)
	})
}
