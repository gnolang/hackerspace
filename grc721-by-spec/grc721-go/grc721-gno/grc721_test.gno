package grc721

import (
	"std"
	"testing"
)

var (
	exampleNFTName   = "ExampleNFT"
	exampleNFTSymbol = "EXNFT"
)

func TestNewGRC721Token(t *testing.T) {
	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
	if exampleNFT == nil {
		t.Errorf("should not be nil")
	}
}

func TestName(t *testing.T) {
	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
	if exampleNFT == nil {
		t.Errorf("should not be nil")
	}
	name := exampleNFT.Name()
	if name != exampleNFTName {
		t.Errorf("expected: (%s), got: (%s)", exampleNFTName, name)
	}
}

func TestSymbol(t *testing.T) {
	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
	if exampleNFT == nil {
		t.Errorf("should not be nil")
	}
	symbol := exampleNFT.Symbol()
	if symbol != exampleNFTSymbol {
		t.Errorf("expected: (%s), got: (%s)", exampleNFTSymbol, symbol)
	}
}

func TestBalanceOf(t *testing.T) {
	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
	if exampleNFT == nil {
		t.Errorf("should not be nil")
	}

	addr1 := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
	addr2 := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")

	balanceAddr1 := exampleNFT.BalanceOf(addr1)

	if balanceAddr1 != 0 {
		t.Errorf("expected: (%d), got: (%d)", 0, balanceAddr1)
	}

	exampleNFT.mint(addr1, "1")
	exampleNFT.mint(addr1, "2")
	exampleNFT.mint(addr2, "3")

	balanceAddr1 = exampleNFT.BalanceOf(addr1)
	balanceAddr2 := exampleNFT.BalanceOf(addr2)

	if balanceAddr1 != 2 {
		t.Errorf("expected: (%d), got: (%d)", 2, balanceAddr1)
	}
	if balanceAddr2 != 1 {
		t.Errorf("expected: (%d), got: (%d)", 1, balanceAddr2)
	}
}

func TestOwnerOf(t *testing.T) {
	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
	if exampleNFT == nil {
		t.Errorf("should not be nil")
	}

	addr1 := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
	addr2 := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")

	exampleNFT.mint(addr1, "1")
	exampleNFT.mint(addr2, "2")

	// Checking for token id "1"
	owner := exampleNFT.OwnerOf("1")

	if owner != addr1 {
		t.Errorf("expected: (%s), got: (%s)", addr1.String(), owner.String())
	}

	// Checking for token id "2"
	owner = exampleNFT.OwnerOf("2")

	if owner != addr2 {
		t.Errorf("expected: (%s), got: (%s)", addr2.String(), owner.String())
	}
}

//func TestIsApprovedForAll(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	addr1 := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//	addr2 := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")
//
//	isApprovedForAll := exampleNFT.IsApprovedForAll(addr1, addr2)
//	if isApprovedForAll != false {
//		t.Errorf("expected: (%v), got: (%v)", false, isApprovedForAll)
//	}
//}
//
//func TestSetApprovalForAll(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	caller := std.PrevRealm().Addr()
//	addr := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//
//	isApprovedForAll := exampleNFT.IsApprovedForAll(caller, addr)
//	if isApprovedForAll != false {
//		t.Errorf("expected: (%v), got: (%v)", false, isApprovedForAll)
//	}
//
//	err := exampleNFT.SetApprovalForAll(addr, true)
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	isApprovedForAll = exampleNFT.IsApprovedForAll(caller, addr)
//	if isApprovedForAll != true {
//		t.Errorf("expected: (%v), got: (%v)", false, isApprovedForAll)
//	}
//}
//
//func TestGetApproved(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	approvedAddr, err := exampleNFT.GetApproved(TokenID("invalid"))
//	if err == nil {
//		t.Errorf("should result in error")
//	}
//}
//
//func TestApprove(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	caller := std.PrevRealm().Addr()
//	addr := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//
//	exampleNFT.mint(caller, TokenID("1"))
//
//	_, err := exampleNFT.GetApproved(TokenID("1"))
//	if err == nil {
//		t.Errorf("should result in error")
//	}
//
//	err = exampleNFT.Approve(addr, TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	approvedAddr, err := exampleNFT.GetApproved(TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if approvedAddr != addr {
//		t.Errorf("expected: (%s), got: (%s)", addr.String(), approvedAddr.String())
//	}
//}
//
//func TestTransferFrom(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	caller := std.PrevRealm().Addr()
//	addr := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//
//	exampleNFT.mint(caller, TokenID("1"))
//	exampleNFT.mint(caller, TokenID("2"))
//
//	err := exampleNFT.TransferFrom(caller, addr, TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	// Check balance of caller after transfer
//	balanceOfCaller, err := exampleNFT.BalanceOf(caller)
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if balanceOfCaller != 1 {
//		t.Errorf("expected: (%d), got: (%d)", 1, balanceOfCaller)
//	}
//
//	// Check balance of addr after transfer
//	balanceOfAddr, err := exampleNFT.BalanceOf(addr)
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if balanceOfAddr != 1 {
//		t.Errorf("expected: (%d), got: (%d)", 1, balanceOfAddr)
//	}
//
//	// Check Owner of transferred Token id
//	owner, err := exampleNFT.OwnerOf(TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if owner != addr {
//		t.Errorf("expected: (%s), got: (%s)", addr.String(), owner.String())
//	}
//}
//
//func TestSafeTransferFrom(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	caller := std.PrevRealm().Addr()
//	addr := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//
//	exampleNFT.mint(caller, TokenID("1"))
//	exampleNFT.mint(caller, TokenID("2"))
//
//	err := exampleNFT.SafeTransferFrom(caller, addr, TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	// Check balance of caller after transfer
//	balanceOfCaller, err := exampleNFT.BalanceOf(caller)
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if balanceOfCaller != 1 {
//		t.Errorf("expected: (%d), got: (%d)", 1, balanceOfCaller)
//	}
//
//	// Check balance of addr after transfer
//	balanceOfAddr, err := exampleNFT.BalanceOf(addr)
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if balanceOfAddr != 1 {
//		t.Errorf("expected: (%d), got: (%d)", 1, balanceOfAddr)
//	}
//
//	// Check Owner of transferred Token id
//	owner, err := exampleNFT.OwnerOf(TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if owner != addr {
//		t.Errorf("expected: (%s), got: (%s)", addr.String(), owner.String())
//	}
//}
//
//func TestMint(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	addr1 := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//	addr2 := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")
//
//	err := exampleNFT.Mint(addr1, TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	err = exampleNFT.Mint(addr1, TokenID("2"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	err = exampleNFT.Mint(addr2, TokenID("3"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	// Try minting duplicate token id
//	err = exampleNFT.Mint(addr2, TokenID("1"))
//	if err == nil {
//		t.Errorf("should result in error")
//	}
//
//	// Check Owner of Token id
//	owner, err := exampleNFT.OwnerOf(TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//	if owner != addr1 {
//		t.Errorf("expected: (%s), got: (%s)", addr1.String(), owner.String())
//	}
//}
//
//func TestBurn(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	addr := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//
//	exampleNFT.mint(addr, TokenID("1"))
//	exampleNFT.mint(addr, TokenID("2"))
//
//	err := exampleNFT.Burn(TokenID("1"))
//	if err != nil {
//		t.Errorf("should not result in error")
//	}
//
//	// Check Owner of Token id
//	owner, err := exampleNFT.OwnerOf(TokenID("1"))
//	if err == nil {
//		t.Errorf("should result in error")
//	}
//}
//
//func TestSetTokenURI(t *testing.T) {
//	exampleNFT := NewGRC721Token(exampleNFTName, exampleNFTSymbol)
//	if exampleNFT == nil {
//		t.Errorf("should not be nil")
//	}
//
//	addr1 := std.Address("g1var589z07ppjsjd24ukm4uguzwdt0tw7g47cgm")
//	addr2 := std.Address("g1us8428u2a5satrlxzagqqa5m6vmuze025anjlj")
//	tokenURI := "http://example.com/token"
//
//	std.TestSetOrigCaller(std.Address(addr1)) // addr1
//
//	exampleNFT.mint(addr1, TokenID("1"))
//	_, derr := exampleNFT.SetTokenURI(TokenID("1"), TokenURI(tokenURI))
//
//	if derr != nil {
//		t.Errorf("Should not result in error ", derr.Error())
//	}
//
//	// Test case: Invalid token ID
//	_, err := exampleNFT.SetTokenURI(TokenID("3"), TokenURI(tokenURI))
//	if err != ErrInvalidTokenId {
//		t.Errorf("Expected error %v, got %v", ErrInvalidTokenId, err)
//	}
//
//	std.TestSetOrigCaller(std.Address(addr2)) // addr2
//
//	_, cerr := exampleNFT.SetTokenURI(TokenID("1"), TokenURI(tokenURI)) // addr2 trying to set URI for token 1
//	if cerr != ErrCallerIsNotOwner {
//		t.Errorf("Expected error %v, got %v", ErrCallerIsNotOwner, err)
//	}
//
//	// Test case: Retrieving TokenURI
//	std.TestSetOrigCaller(std.Address(addr1)) // addr1
//
//	exampleNFTTokenURI, err := exampleNFT.TokenURI(TokenID("1"))
//	if err != nil {
//		t.Errorf("TokenURI error: %v, ", err.Error())
//	}
//	if exampleNFTTokenURI != tokenURI {
//		t.Errorf("Expected URI %v, got %v", tokenURI, exampleNFTTokenURI)
//	}
//}
