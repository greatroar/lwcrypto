// Code generated by command: go run asm.go -out out/ascon_amd64.s -stubs out/stub_amd64.go -pkg ascon. DO NOT EDIT.

// +build gc,!purego

package ascon

//go:noescape
func p12(s *state)

//go:noescape
func p8(s *state)

//go:noescape
func p6(s *state)

//go:noescape
func round(s *state, C uint64)
