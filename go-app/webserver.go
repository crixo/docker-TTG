package main

import (
	"fmt"
	"net/http"
)

func main() {
	port := "80"
	http.HandleFunc("/", func (w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Welcome to my website!")
	})

	// http.HandleFunc("/ttg", func (w http.ResponseWriter, r *http.Request) {
	// 	fmt.Fprintf(w, "Welcome to TTG!")
	// })

	fs := http.FileServer(http.Dir("static/"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	done := make(chan bool)
    go http.ListenAndServe(":"+port, nil)
    fmt.Printf("Server started at port %v", port)
    <-done
}