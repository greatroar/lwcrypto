package grain

import (
	"bufio"
	"bytes"
	"crypto/cipher"
	"encoding/hex"
	"fmt"
	"math"
	"math/rand"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestNext(t *testing.T) {
	key := make([]byte, KeySize)
	nonce := make([]byte, NonceSize)
	for i := 0; i < 1_000; i++ {
		if _, err := rand.Read(key); err != nil {
			t.Fatal(err)
		}
		if _, err := rand.Read(nonce); err != nil {
			t.Fatal(err)
		}

		var g1 state
		g1.setKey(key)
		g1.init(nonce)

		var g2 state
		g2.setKey(key)
		g2.init(nonce)

		for j := 0; j < 10_000; j++ {
			v1 := nextGeneric(&g1)
			v2 := next(&g2)
			if v1 != v2 {
				if g1 != g2 {
					fmt.Println("mismatch")
					fmt.Println(g1.lfsr == g2.lfsr)
					for i := range g1.lfsr {
						if g1.lfsr[i] != g2.lfsr[i] {
							fmt.Printf("mismatch %#x vs %#x at %d\n",
								g1.lfsr[i], g2.lfsr[i], i)
						}
					}
					fmt.Println(g1.nfsr == g2.nfsr)
					for i := range g1.nfsr {
						if g1.nfsr[i] != g2.nfsr[i] {
							fmt.Printf("mismatch %#x vs %#x at %d\n",
								g1.nfsr[i], g2.nfsr[i], i)
						}
					}
				}
				t.Fatalf("#%d (#%d): expected %#x, got %#x", i, j, v1, v2)
			}
		}
	}
}

func TestAuth(t *testing.T) {
	key := make([]byte, KeySize)
	nonce := make([]byte, NonceSize)
	for i := 0; i < 256; i++ {
		if _, err := rand.Read(key); err != nil {
			t.Fatal(err)
		}
		if _, err := rand.Read(nonce); err != nil {
			t.Fatal(err)
		}

		var g1 state
		g1.setKey(key)
		g1.init(nonce)

		var g2 state
		g2.setKey(key)
		g2.init(nonce)

		for j := 0; j < math.MaxUint16; j++ {
			accumulateGeneric(&g1, uint16(j), uint16(i))
			accumulate(&g2, uint16(j), uint16(i))
			if g1.wtf != g2.wtf {
				t.Fatalf("#%d (#%d): expected %#x, got %#x", i, j, g1.wtf, g2.wtf)
			}
			if g1.acc != g2.acc {
				t.Fatalf("#%d (#%d): expected %#x, got %#x", i, j, g1.acc, g2.acc)
			}
			if g1.reg != g2.reg {
				t.Fatalf("#%d (#%d): expected %#x, got %#x", i, j, g1.reg, g2.reg)
			}
		}
	}
}

func TestVectorsLE(t *testing.T) {
	testVectors(t, New, filepath.Join("testdata", "little_endian.txt"))
}

func testVectors(t *testing.T, fn func([]byte) (cipher.AEAD, error), path string) {
	vecs, err := readVecs(path)
	if err != nil {
		t.Fatal(err)
	}
	for i, v := range vecs {
		c, err := fn(v.key)
		if err != nil {
			t.Fatalf("#%d: %v", i+1, err)
		}
		ciphertext := c.Seal(nil, v.nonce, v.pt, v.ad)
		if !bytes.Equal(ciphertext, v.ct) {
			t.Fatalf("#%d: expected %#x, got %#x", i+1, v.ct, ciphertext)
		}
		plaintext, err := c.Open(nil, v.nonce, v.ct, v.ad)
		if err != nil {
			t.Fatalf("#%d: %v", i+1, err)
		}
		if !bytes.Equal(plaintext, v.pt) {
			t.Fatalf("#%d: expected %#x, got %#x", i+1, v.pt, plaintext)
		}
	}
}

func BenchmarkSeal1K(b *testing.B) {
	benchmarkSeal(b, New, make([]byte, 1024))
}

func BenchmarkOpen1K(b *testing.B) {
	benchmarkOpen(b, New, make([]byte, 1024))
}

func BenchmarkSeal8K(b *testing.B) {
	benchmarkSeal(b, New, make([]byte, 8*1024))
}

func BenchmarkOpen8K(b *testing.B) {
	benchmarkOpen(b, New, make([]byte, 8*1024))
}

func benchmarkSeal(b *testing.B, fn func([]byte) (cipher.AEAD, error), buf []byte) {
	b.SetBytes(int64(len(buf)))

	key := make([]byte, KeySize)
	nonce := make([]byte, NonceSize)
	ad := make([]byte, 13)
	aead, err := fn(key)
	if err != nil {
		b.Fatal(err)
	}
	var out []byte

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		out = aead.Seal(out[:0], nonce, buf, ad)
	}
}

func benchmarkOpen(b *testing.B, fn func([]byte) (cipher.AEAD, error), buf []byte) {
	b.SetBytes(int64(len(buf)))

	key := make([]byte, KeySize)
	nonce := make([]byte, NonceSize)
	ad := make([]byte, 13)
	aead, err := fn(key)
	if err != nil {
		b.Fatal(err)
	}
	var out []byte
	out = aead.Seal(out[:0], nonce, buf, ad)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := aead.Open(buf[:0], nonce, out, ad)
		if err != nil {
			b.Errorf("Open: %v", err)
		}
	}
}

type vector struct {
	key   []byte
	nonce []byte
	pt    []byte
	ad    []byte
	ct    []byte
}

func (v *vector) set(field string, p []byte) bool {
	switch field {
	case "Key":
		v.key = p
	case "Nonce":
		v.nonce = p
	case "PT":
		v.pt = p
	case "AD":
		v.ad = p
	case "CT":
		v.ct = p
	default:
		return false
	}
	return true
}

func readVecs(path string) ([]vector, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var vecs []vector

	s := bufio.NewScanner(f)
	for i := 0; s.Scan(); i++ {
		t := s.Text()
		if t == "" {
			continue
		}
		if strings.HasPrefix(t, "Count = ") {
			vecs = append(vecs, vector{})
			continue
		}
		i := strings.IndexByte(t, '=')
		if i < 0 {
			return nil, fmt.Errorf("malformed line %d: %q", i+1, t)
		}
		data := strings.TrimSpace(t[i+1:])
		buf, err := hex.DecodeString(data)
		if err != nil {
			return nil, fmt.Errorf("malformed line %d: %v", i+1, err)
		}
		field := strings.TrimSpace(t[:i])
		if !vecs[len(vecs)-1].set(field, buf) {
			return nil, fmt.Errorf("malformed line %d: %q", i+1, t)
		}
	}
	return vecs, nil
}
