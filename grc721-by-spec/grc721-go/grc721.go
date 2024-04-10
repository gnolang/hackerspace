package grc721

import (
	"github.com/gnolang/gno/examples/gno.land/p/demo/avl"
	"github.com/gnolang/gno/examples/gno.land/p/demo/ufmt"
	"github.com/gnolang/gno/gnovm/stdlibs/std"
)

type GRC721 struct {
	name              string
	symbol            string
	owners            *avl.Tree // tokenID > std.Address
	balances          *avl.Tree // std.Address > # of owned tokens
	tokenApprovals    *avl.Tree // tokenID > std.Address
	operatorApprovals *avl.Tree // "OwnerAddress:OperatorAddress" -> bool
	tokenURIs         *avl.Tree // tokenID > URI
}

func NewGRC721Token(name, symbol string) *GRC721 {
	return &GRC721{
		name:     name,
		symbol:   symbol,
		owners:   avl.NewTree(),
		balances: avl.NewTree(),
		// give an address permission to a specific tokenID
		tokenApprovals: avl.NewTree(),
		// give any addresses permissions for all owners' assets
		operatorApprovals: avl.NewTree(),
		tokenURIs:         avl.NewTree(),
	}
}

func (nft GRC721) Name() string   { return nft.name }
func (nft GRC721) Symbol() string { return nft.symbol }

func (nft GRC721) BalanceOf(owner std.Address) uint64 {
	if !owner.IsValid() {
		panic("owner address is not valid")
	}
	balance, found := nft.balances.Get(owner.String())
	if !found {
		return 0
	}

	return balance.(uint64)
}

func (nft GRC721) OwnerOf(tokenId string) std.Address {
	owner := nft.requireOwned(tokenId)
	return owner
}

func (nft GRC721) TransferFrom(from, to std.Address, tokenId string) {
	if !to.IsValid() {
		panic(ufmt.Errorf("%s %s", ErrGRC721InvalidReceiver, to))
	}

	if nft.requireOwned(tokenId) != from {
		panic(ufmt.Errorf("%s %s", ErrGRC721InvalidReceiver, to))
	}

}

func (nft GRC721) Approve(to std.Address, tokenId string) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) SetApprovalForAll(operator std.Address, approved bool) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) GetApproved(tokenId string) std.Address {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) IsApprovedForAll(owner, operator std.Address) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) TokenURI(tokenId string) string {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) SetTokenURI(tokenId string, tokenURI string) string {
	//TODO implement me
	panic("implement me")
}

// Helpers

// requireOwned returns the owner of the token, or an empty string if token does not have an owner
// Token cannot have an owner only if it has not been minted yet, or if it has been burned.
func (nft GRC721) requireOwned(tokenId string) std.Address {
	owner, exists := nft.owners.Get(tokenId)
	if !exists {
		panic(ufmt.Errorf("%s with id %s", ErrGRC721NonexistentToken, tokenId))
	}

	return owner.(std.Address)
}
