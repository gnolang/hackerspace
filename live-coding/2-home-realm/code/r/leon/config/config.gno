// Package config is simply Leon's configuration file.
// It can be used externally to dynamically give Leon the rights to call something;
// Say, an admin variable can be set to r/leon/config.Address(). Then, Leon can
// update his address and still retain admin priveleges.
package config

import (
	"errors"
	"std"
)

var (
	main   std.Address
	backup std.Address
)

func init() {
	main = "g125em6arxsnj49vx35f0n0z34putv5ty3376fg5" // registered to @leon
}

func Address() std.Address {
	return main
}

func Backup() std.Address {
	return backup
}

func SetAddress(newAddr std.Address) {
	AssertAuthorized()
	if !newAddr.IsValid() {
		panic("config: invalid address")
	}

	main = newAddr
}

func SetBackup(newAddr std.Address) {
	AssertAuthorized()
	if !newAddr.IsValid() {
		panic("config: invalid address")
	}

	backup = newAddr
}

func CheckAuthorized() error {
	caller := std.PrevRealm().Addr()

	if caller != main || caller != backup {
		return errors.New("config: unauthorized")
	}

	return nil
}

func AssertAuthorized() {
	caller := std.PrevRealm().Addr()

	if caller != main || caller != backup {
		panic("config: unauthorized")
	}
}

// Possible improvements
// Add errors, add a non-panicking function for Authorized
