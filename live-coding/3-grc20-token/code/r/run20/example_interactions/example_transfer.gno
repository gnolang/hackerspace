package main

import (
	leon "gno.land/r/leon/token"
)

// using the Transfer method of the grc20.Token interface, which is the type of `leon.Token`
// read more about Run in the official gno.land docs
func main() {
	leon.Token.Transfer("g10ahumypepd2qcrau7kahv8q78f7jcdns5tn54a", 10_000*1_000_000)
	leon.Token.Transfer("g13awn2575t8s2vf3svlprc4dg0e9z5wchejdxk8", 10_000*1_000_000)
	leon.Token.Transfer("g162jgpk4740r6a7g53cgz9ahxqtyuekgqchw6w9", 10_000*1_000_000)
}
