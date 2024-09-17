package run20

import "gno.land/p/demo/grc/grc20"

var (
	// bank is a new instance of the grc20.Banker type which contains admin functionality, such as mint, burn, etc
	// should not be exported, unless you want to expose mint & burn functionality to all users
	bank = grc20.NewBanker("Gno Live Coding #3 Token", "LCS3", 6)
	// Token is an instance of the interface grc20.Token following the fungible token spec.
	// Token can be safely exposed, as contains only the subset of banker functionalities which are non-admin related.
	// This is why it is called a "safe object" - it's safe to expose to the public.
	Token = bank.Token()
)

func init() {
	// minting initial balances
	_ = bank.Mint("g125em6arxsnj49vx35f0n0z34putv5ty3376fg5", 10000000000000)   // leon
	_ = bank.Mint("g10ahumypepd2qcrau7kahv8q78f7jcdns5tn54a", 10_000*1_000_000) // malek
	_ = bank.Mint("g13awn2575t8s2vf3svlprc4dg0e9z5wchejdxk8", 10_000*1_000_000) // stefan n
	_ = bank.Mint("g162jgpk4740r6a7g53cgz9ahxqtyuekgqchw6w9", 10_000*1_000_000) // varmeta
}

func Render(_ string) string {
	return bank.RenderHome()
}
