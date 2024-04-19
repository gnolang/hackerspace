package grc721

import (
	"github.com/gnolang/gno/examples/gno.land/p/demo/avl"
	"github.com/gnolang/gno/examples/gno.land/p/demo/ufmt"
	"github.com/gnolang/gno/gnovm/stdlibs/std"
)

type Token struct {
	name              string
	symbol            string
	owners            *avl.Tree // tokenID > std.Address
	balances          *avl.Tree // std.Address > # of owned tokens
	tokenApprovals    *avl.Tree // tokenID > std.Address
	operatorApprovals *avl.Tree // "OwnerAddress:OperatorAddress" -> bool
	tokenURIs         *avl.Tree // tokenID > URI
}

func NewGRC721Token(name, symbol string) *Token {
	return &Token{
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

func (nft Token) Name() string   { return nft.name }
func (nft Token) Symbol() string { return nft.symbol }

func (nft Token) BalanceOf(owner std.Address) uint64 {
	mustBeValid(owner)

	balance, found := nft.balances.Get(owner.String())
	if !found {
		return 0
	}

	return balance.(uint64)
}

func (nft Token) OwnerOf(tokenId string) std.Address {
	return nft.mustBeOwned(tokenId)
}

func (nft Token) TransferFrom(from, to std.Address, tokenId string) {
	caller := std.PrevRealm().Addr()

	mustBeValid(to)
	// caller must be:
	// owner, approved, or operator

}

func (nft Token) Approve(to std.Address, tokenId string) {
	caller := std.PrevRealm().Addr()

	nft.requireOwner(caller, tokenId)
	mustBeValid(to)

	nft.tokenApprovals.Set(tokenId, to)
}

func (nft Token) SetApprovalForAll(operator std.Address, approved bool) {
	caller := std.PrevRealm().Addr()
	if caller == operator {
		panic("GRC721: cannot set operator to yourself")
	}

	nft.operatorApprovals.Set(operatorKey(caller, operator), approved)
}

// View func - just return empty or error, do not panic?
func (nft Token) GetApproved(tokenId string) std.Address {
	_ = nft.mustBeOwned(tokenId)
	approved, exists := nft.tokenApprovals.Get(tokenId)
	if !exists {
		return ""
	}

	return approved.(std.Address)
}

// View func - just return empty or error, do not panic?
func (nft Token) IsApprovedForAll(owner, operator std.Address) bool {
	approved, exists := nft.operatorApprovals.Get(operatorKey(owner, operator))
	if !exists || approved == false {
		return false
	}

	return true
}

// Helpers

func (nft Token) requireOwner(caller std.Address, tokenId string) {
	if caller != nft.mustBeOwned(tokenId) {
		panic("Token: not owner")
	}
}

// mustBeValid panics if the given address is not valid
func mustBeValid(address std.Address) {
	if !address.IsValid() {
		err := ufmt.Sprintf("GRC721: invalid address %s", address)
		panic(err)
	}
}

// mustBeOwned panics if token is not owned by an address (does not exist)
// If the token is owned, mustBeOwned returns the owner of the token
func (nft Token) mustBeOwned(tokenId string) std.Address {
	owner, exists := nft.balances.Get(tokenId)
	if !exists {
		err := ufmt.Sprintf("GRC721: token with id %s does not exist", tokenId)
		panic(err)
	}

	return owner.(std.Address)
}

// checkAuthorized checks if address is either approved or ..?
func checkAuthorized(address std.Address, tokenId string) {

}

// operatorKey is a helper to create the key for the operatorApproval tree
func operatorKey(owner, operator std.Address) string {
	return owner.String() + ":" + operator.String()
}
