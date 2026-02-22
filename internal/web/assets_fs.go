//go:build !embed

package web

import (
	"io/fs"
	"os"
)

// DistFS returns a filesystem rooted at the built frontend assets.
//
// In default (non-embed) builds, we read frontend/dist from disk.
//
// Assumption: run from repo root (make run / go run from root).
func DistFS() (fs.FS, error) {
	return os.DirFS("frontend/dist"), nil
}
