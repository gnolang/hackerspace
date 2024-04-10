package grc721

import "errors"

var (
	ErrGRC721NonexistentToken = errors.New("GRC721 non existent token")
	ErrGRC721InvalidReceiver  = errors.New("GRC721 invalid receiver address")
	ErrGRC721NotOwner         = errors.New("GRC721 not owner")
)
