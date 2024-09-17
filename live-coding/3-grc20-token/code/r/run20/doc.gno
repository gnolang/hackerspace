// Package run20 showcases a simple way to create a GRC20 token using the p/demo/grc/grc20 package.
// This package also showcases how to use the MsgRun message type:
// Exposing a variable of a type that contains exposed methods will expose those methods to the end-user as well.
// In this example, it is the grc20.Token interface type.
// Currently, the only way to interact with it is via MsgRun (https://docs.gno.land/gno-tooling/cli/gnokey/state-changing-calls#the-power-of-run)
// The `example_interactions` folder contains Gno scripts that can be provided to the Run transactions to execute these methods.
// This functionality is planned for MsgCall as well in the future.
// For more token examples, check out wugnot, foo20, and bar20 in the examples/ folder in the Gno monorepo.
package run20
