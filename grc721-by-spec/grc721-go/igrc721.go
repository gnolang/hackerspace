package grc721

import "github.com/gnolang/gno/tm2/pkg/crypto"

type IGRC721 interface {
	// BalanceOf returns the number of tokens in `owner`'s account
	BalanceOf(owner crypto.Address) int

	// OwnerOf returns the owner of the `tokenId` token
	// tokenId must exist
	OwnerOf(tokenId int) crypto.Address

	// TransferFrom transfers `tokenId` token from `from` to `to`
	TransferFrom(from, to crypto.Address, tokenId int)

	// Approve gives permission to `to` to transfer `tokenId` token to another account
	// The approval is cleared when the token is transferred
	Approve(to crypto.Address, tokenId int)

	// SetApprovalForAll approves or removes `operator` as an operator for the caller
	// Operators can call TransferFrom for any token owned by the caller
	SetApprovalForAll(operator crypto.Address, approved bool)

	// GetApproved returns the account approved for `tokenId` token
	GetApproved(tokenId int) crypto.Address

	// IsApprovedForAll returns if the `operator` is allowed to manage all the assets of `owner`
	IsApprovedForAll(owner, operator crypto.Address)

	// TokenURI gets the tokenURI for matching `tokenId`
	TokenURI(tokenId int) string

	// SetTokenURI sets `tokenURI` as the tokenURI of `tokenId`
	SetTokenURI(tokenId int, tokenURI string) string
}
