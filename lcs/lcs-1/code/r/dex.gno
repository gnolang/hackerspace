package lcsdex

import (
	"std"
	"strconv"

	"gno.land/p/demo/ufmt"
	"gno.land/p/demo/users"
	"gno.land/r/demo/foo20"
	"gno.land/r/demo/wugnot"
)

// Possible improvements to this code
// Handle multiple liquidity pools to allow for any grc20 swap
// Implement rewards for liquidity providers
// Improve rendering & error messages
// Add tests

type LastTrade struct {
	addr      std.Address
	amtWugnot uint64
	amtFoo20  uint64
	typ       string // "wff" || "ffw"
}

var (
	wugnotReserve uint64
	foo20Reserve  uint64
	dexAddr       = std.CurrentRealm().Addr() // Realm{pkgPath, address} // std.Address
	lt            *LastTrade
)

// constant product amm -> k = x * y

// amm -> LP (reserves of tokens) > who provides reseves
// Please, use grc20.Approve before calling this function
func AddLiquidity(fooAmt, wugnotAmt uint64) string {
	// add both wugnot & foo20 reserves
	// provide equal amounts
	// user provides amounts
	// approves beforehand
	if fooAmt == 0 || wugnotAmt == 0 {
		panic("you need to provide both tokens to the liquidity pool")
	}

	if fooAmt != wugnotAmt {
		panic("provided amounts need to be the same")
	}

	caller := std.PrevRealm().Addr() // std.Address // type Address string
	// todo: implement fee system

	foo20.TransferFrom(users.AddressOrName(caller.String()), users.AddressOrName(dexAddr.String()), fooAmt)
	wugnot.TransferFrom(users.AddressOrName(caller.String()), users.AddressOrName(dexAddr.String()), wugnotAmt)

	wugnotReserve += wugnotAmt
	foo20Reserve += fooAmt

	return ufmt.Sprintf("successfully deposited %d wugnot & %d foo20", wugnotAmt, fooAmt)
}

func SwapWugnotForFoo20(amtInWugnot, amtOutFoo20 uint64) string {
	if amtInWugnot == 0 || amtOutFoo20 == 0 {
		panic("you need to provide both in and out amounts")
	}

	// k = x * y
	k := wugnotReserve * foo20Reserve

	newWugnotReserve := wugnotReserve + amtInWugnot
	newFoo20Reserve := k / newWugnotReserve

	amtOut := foo20Reserve - newFoo20Reserve

	if amtOut < amtOutFoo20 {
		msg := ufmt.Sprintf("not enough liquidity. you can only get %d foo20 for %d wugnot", amtOut, amtInWugnot)
		panic(msg)
	}

	caller := std.PrevRealm().Addr()
	wugnot.TransferFrom(users.AddressOrName(caller.String()), users.AddressOrName(dexAddr.String()), amtInWugnot)
	foo20.Transfer(users.AddressOrName(caller.String()), amtOutFoo20)

	wugnotReserve = newWugnotReserve
	foo20Reserve = newFoo20Reserve

	lt = &LastTrade{
		addr:      caller,
		amtWugnot: amtInWugnot,
		amtFoo20:  amtOutFoo20,
		typ:       "wff", // wugnot for foo20
	}

	return ufmt.Sprintf("successfully swapped %d wugnot for %d foo20", amtInWugnot, amtOutFoo20)
}

func SwapFoo20ForWugnot(amtInFoo20, amountOutWugnot uint64) string {
	if amtInFoo20 == 0 || amountOutWugnot == 0 {
		panic("you need to provide both in and out amounts")
	}

	// k = x * y
	k := wugnotReserve * foo20Reserve

	newFoo20Reserve := foo20Reserve + amtInFoo20
	newWugnotReserve := k / newFoo20Reserve

	amtOut := wugnotReserve - newWugnotReserve

	if amtOut < amountOutWugnot {
		msg := ufmt.Sprintf("not enough liquidity. you can only get %d wugnot for %d foo20", amtOut, amtInFoo20)
		panic(msg)
	}

	caller := std.PrevRealm().Addr()
	foo20.TransferFrom(users.AddressOrName(caller.String()), users.AddressOrName(dexAddr.String()), amtInFoo20)
	wugnot.Transfer(users.AddressOrName(caller.String()), amountOutWugnot)

	wugnotReserve = newWugnotReserve
	foo20Reserve = newFoo20Reserve

	lt = &LastTrade{
		addr:      caller,
		amtWugnot: amountOutWugnot,
		amtFoo20:  amtInFoo20,
		typ:       "ffw", // foo20 for wugnot
	}

	return ufmt.Sprintf("successfully swapped %d foo20 for %d wugnot", amtInFoo20, amountOutWugnot)
}

func Render(_ string) string {
	output := "# GRC20 Simple DEX\n\n"

	output += ufmt.Sprintf("DEX Address: %s\n\n", dexAddr.String())
	output += ufmt.Sprintf("Liquidity: %d wugnot, %d foo20\n\n", wugnotReserve, foo20Reserve)
	output += ufmt.Sprintf("1 wugnot = %s foo20\n\n", manualFloat(wugnotReserve, foo20Reserve))
	output += ufmt.Sprintf("1 foo20 = %s wugnot\n\n", manualFloat(foo20Reserve, wugnotReserve))

	if lt != nil {
		output += "### Last Swap\n\n"

		if lt.typ == "wff" {
			output += ufmt.Sprintf("%s traded %d wugnot for %d foo20", lt.addr.String(), lt.amtWugnot, lt.amtFoo20)
		} else {
			output += ufmt.Sprintf("%s traded %d foo20 for %d wugnot", lt.addr.String(), lt.amtFoo20, lt.amtWugnot)
		}
	}

	return output
}

func manualFloat(a, b uint64) string {
	quotient := a / b
	remainder := a % b

	quotientStr := strconv.FormatUint(quotient, 10)
	scaledRemainder := (remainder * 1000000) / b
	remainderStr := strconv.FormatUint(scaledRemainder, 10)

	return quotientStr + "." + remainderStr
}
