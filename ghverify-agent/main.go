package main

// subscribe to indexer events
// poll GH api for repo under specific username
// sent TX as whitelisted agent to verify

import (
	"fmt"
	"github.com/gnolang/gno/gno.land/pkg/gnoclient"
	"github.com/gnolang/gno/gno.land/pkg/sdk/vm"
	"github.com/gnolang/gno/gnovm/pkg/gnoenv"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto/keys"
	"io"
	"net/http"
)

const (
	plID         = "portal-loop"
	plRPC        = "https://rpc.gno.land:443"
	ghverifyPath = "gno.land/r/gnoland/ghverify"
)

func main() {
	// Initialize keybase from a directory
	kb, _ := keys.NewKeyBaseFromDir(gnoenv.HomeDir())

	// Create signer
	signer := gnoclient.SignerFromKeybase{
		Keybase:  kb,
		Account:  "main",
		Password: "",
		ChainID:  plID,
	}

	// Initialize the RPC client
	rpc, err := rpcclient.NewHTTPClient(plRPC)
	if err != nil {
		panic(err)
	}

	// Initialize the gnoclient
	client := gnoclient.Client{
		Signer:    signer,
		RPCClient: rpc,
	}

	keyInfo, err := signer.Info()
	if err != nil {
		panic(err)
	}

	acc, _, err := client.QueryAccount(keyInfo.GetAddress())
	if err != nil {
		panic(err)
	}

	baseCfg := gnoclient.BaseTxCfg{
		GasFee:         "1ugnot",
		GasWanted:      100000,
		AccountNumber:  acc.GetAccountNumber(),
		SequenceNumber: acc.GetSequence(),
		Memo:           "hackerspace: ghverify-agent",
	}

	// catchEvent() -> get addr + username pair

	// checkGitHubRepo(addr, repo)

	arg := "ingest," + "addr" + ",OK"

	msg := vm.MsgCall{
		Caller:  keyInfo.GetAddress(),
		Send:    nil,
		PkgPath: ghverifyPath,
		Func:    "GnorkleEntryPoint",
		Args:    []string{arg},
	}

	res, err := client.Call(baseCfg)
	println(res)
}

func checkGitHubRepo(owner, repo string) bool {
	// Construct the GitHub API URL
	url := fmt.Sprintf("https://api.github.com/repos/%s/%s", owner, repo)

	// Send a GET request to the GitHub API
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println("Error:", err)
		return false
	}
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			panic(err)
		}
	}(resp.Body)

	// Check if the status code is 200 (OK) or 404 (Not Found)
	if resp.StatusCode == http.StatusOK {
		return true
	}

	return false
}
