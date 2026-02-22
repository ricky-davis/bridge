//go:build embed

package web

import (
	"embed"
	"io/fs"
)

// dist contains the built frontend assets.
//
// We embed from internal/web/dist to satisfy go:embed path restrictions.
// The Makefile copies frontend/dist -> internal/web/dist before building.
//
//go:embed dist/**
var dist embed.FS

// DistFS returns a filesystem rooted at the embedded dist directory.
func DistFS() (fs.FS, error) {
	return fs.Sub(dist, "dist")
}
