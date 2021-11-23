package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
// 	"log"
)

type handler struct {
	key   []byte
	stats map[string]uint64
}

func (h handler) health(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(200)
}

func (h handler) token(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    h.stats["requests"] += 1

	body, _ := io.ReadAll(r.Body)
    response, err := getJsonResponse(body, h.key)
    if err != nil {
        panic(err)
    }

	fmt.Fprintf(w, string(response))
	w.WriteHeader(200)
}

func (h handler) metrics(w http.ResponseWriter, r *http.Request) {
	enc := json.NewEncoder(w)
	enc.Encode(h.stats)
	w.WriteHeader(201)
}

func getJsonResponse(message, key []byte)([]byte, error)  {
    out := createMAC(message, key)
    mac := fmt.Sprintf("%x", out)

    payload := make(map[string] string)
    payload["hashcode"] = mac

    return json.MarshalIndent(payload, "", "  ")
}

func createMAC(message, key []byte) []byte {
	mac := hmac.New(sha1.New, key)
	mac.Write(message)
	return mac.Sum(nil)
}
