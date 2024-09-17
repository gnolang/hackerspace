package main

import (
	leon "gno.land/r/leon/token"
)

// using the Approve method of the grc20.Token interface, which is the type of `leon.Token`
// read more about Run in the official gno.land docs
func main() {
	leon.Token.Approve("g10ahumypepd2qcrau7kahv8q78f7jcdns5tn54a", 10_000*1_000_000)
}
