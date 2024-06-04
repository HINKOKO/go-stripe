package encryption

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"io"
)

type Encryption struct {
	Key []byte
}

func (e *Encryption) Encrypt(text string) (string, error) {
	plainText := []byte(text)
	block, err := aes.NewCipher(e.Key)
	if err != nil {
		return "", err
	}

	cypherText := make([]byte, aes.BlockSize+len(plainText))
	iv := cypherText[:aes.BlockSize]
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return "", err
	}

	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(cypherText[aes.BlockSize:], plainText)

	// safe to use on a web page
	return base64.URLEncoding.EncodeToString(cypherText), nil
}

func (e *Encryption) Decrypt(cryptoText string) (string, error) {
	cypherText, _ := base64.URLEncoding.DecodeString(cryptoText)
	block, err := aes.NewCipher(e.Key)
	if err != nil {
		return "", err
	}

	if len(cypherText) < aes.BlockSize {
		return "", err
	}

	iv := cypherText[:aes.BlockSize]
	cypherText = cypherText[aes.BlockSize:]

	stream := cipher.NewCFBDecrypter(block, iv)
	stream.XORKeyStream(cypherText, cypherText)

	return fmt.Sprintf("%s", cypherText), nil
}
