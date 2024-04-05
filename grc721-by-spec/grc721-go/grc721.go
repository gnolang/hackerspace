package grc721

import (
	"github.com/gnolang/gno/examples/gno.land/p/demo/avl"
	"github.com/gnolang/gno/tm2/pkg/crypto"
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
		name:              name,
		symbol:            symbol,
		owners:            avl.NewTree(),
		balances:          avl.NewTree(),
		tokenApprovals:    avl.NewTree(),
		operatorApprovals: avl.NewTree(),
		tokenURIs:         avl.NewTree(),
	}
}

func (nft GRC721) Name() string   { return nft.name }
func (nft GRC721) Symbol() string { return nft.symbol }

func (nft GRC721) BalanceOf(owner crypto.Address) int {
	if !owner.IsValid() {
		panic("owner address is not valid")
	}

	balance, found := nft.balances.Get(owner.String())
	if !found {
		return 0
	}

	return balance.(uint64), nil
}

func (nft GRC721) OwnerOf(tokenId int) crypto.Address {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) TransferFrom(from, to crypto.Address, tokenId int) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) Approve(to crypto.Address, tokenId int) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) SetApprovalForAll(operator crypto.Address, approved bool) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) GetApproved(tokenId int) crypto.Address {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) IsApprovedForAll(owner, operator crypto.Address) {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) TokenURI(tokenId int) string {
	//TODO implement me
	panic("implement me")
}

func (nft GRC721) SetTokenURI(tokenId int, tokenURI string) string {
	//TODO implement me
	panic("implement me")
}
