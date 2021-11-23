package main

import (
	"net/http"
	"log"
	"os"
)

var requestIPs []string

func main() {
    statistics := make(map[string]uint64)
    statistics["requests"] = 1
	h := &handler{
		key: []byte(os.Getenv("SECRET")),
		stats: statistics}
	http.HandleFunc("/token", h.token)
	http.HandleFunc("/metrics", h.metrics)
	http.HandleFunc("/health", h.health)
	log.Print(http.ListenAndServe(":8080", nil))
}
