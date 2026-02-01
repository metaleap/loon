package main

import (
	"os"

	"loon/lsp"
)

func main() {
	if len(os.Args) < 2 {
		panic("expected command, one of: lsp, repl, run")
	}

	switch cmd_name := os.Args[1]; cmd_name {
	case "lsp":
		lsp.Main()
	default:
		panic("command '" + cmd_name + "' not implemented")
	}
}
