package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	port := "80"
	http.HandleFunc("/", func (w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Welcome to my website!")
	})

	http.HandleFunc("/env-var", func (w http.ResponseWriter, r *http.Request) {
		msg := "has not been specified"
		
		keys, ok := r.URL.Query()["k"]
		if ok {
			v := os.Getenv(keys[0])
			if len(v) == 0{
				msg = keys[0] + " is undefined"
			}else{
				msg = keys[0] + " is " + v
			}
		}
		
		fmt.Fprintf(w, "Environment Variable " + msg)

		fmt.Println("Logging to the stdout " + msg)
	})

	// http.HandleFunc("/ttg", func (w http.ResponseWriter, r *http.Request) {
	// 	fmt.Fprintf(w, "Welcome to TTG!")
	// })

	fs := http.FileServer(http.Dir("static/"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	done := make(chan bool)
    go http.ListenAndServe(":"+port, nil)
    fmt.Printf("Server started at port %v\n", port)
    <-done
}