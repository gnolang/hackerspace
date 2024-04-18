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
	return nft.owned(tokenId)
}

func (nft GRC721) TransferFrom(from, to std.Address, tokenId string) {
	if !to.IsValid() {
		panic(ufmt.Errorf("%s %s", ErrGRC721InvalidReceiver, to))
	}

	if nft.owned(tokenId) != from {
		panic(ufmt.Errorf("%s %s", ErrGRC721InvalidReceiver, to))
	}
}

func (nft GRC721) Approve(to std.Address, tokenId string) {
	caller := std.PrevRealm().Addr()

	nft.requireOwner(caller, tokenId)
	requireValid(to)

	nft.tokenApprovals.Set(tokenId, to)
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

// Helpers

// owned panics if token is not owned by an address(does not exist)
// if the token is owned, return the owner
func (nft GRC721) owned(tokenId string) std.Address {
	owner, exists := nft.balances.Get(tokenId)
	if !exists {
		err := ufmt.Sprintf("GRC721: token with id %s does not exist", tokenId)
		panic(err)
	}

	return owner.(std.Address)
}

func (nft GRC721) requireOwner(caller std.Address, tokenId string) {
	if caller != nft.owned(tokenId) {
		panic("GRC721: not owner")
	}
}

func requireValid(address std.Address) {
	if !address.IsValid() {
		err := ufmt.Sprintf("GRC721: invalid address %s", address)
		panic(err)
	}
}
