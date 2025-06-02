{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go # The Go compiler and tools
    gopls # LSP server for Go (highly recommended for IDEs)
    delve # Go debugger
    # Additional useful Go tools
    # go-tools # A collection of common Go tools
  ];

  # Set GOPATH environment variable if not using Go modules exclusively
  # (Go modules generally make GOPATH less critical, but some older setups might need it)
  environment.sessionVariables.GOPATH = "$HOME/go-pkg";

  # Ensure the Go bin directory is in the PATH
  environment.sessionVariables.PATH = [ "$GOPATH/bin" ];
}
