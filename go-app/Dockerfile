# https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324
# https://weberc2.bitbucket.io/posts/golang-docker-scratch-app.html
# https://medium.com/@rrgarciach/bootstrapping-a-go-application-with-docker-47f1d9071a2a
############################
# STEP 1 build executable binary
############################
#FROM golang:alpine AS builder
FROM golang:1.13.3-alpine3.10 AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git
# https://www.yellowduck.be/posts/compile-using-a-docker-container/
RUN apk add gcc libc-dev make git
WORKDIR $GOPATH/src/myapp
COPY . .
# Fetch dependencies.
# Using go get.
RUN go get -d -v
# Build the binary.
#ENV CGO_ENABLED=0
#RUN go build -o /go/bin/dino
# https://stackoverflow.com/questions/55106186/no-such-file-or-directory-with-docker-scratch-image
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/myapp
############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/myapp /go/bin/myapp
# Run the hello binary.
ENTRYPOINT ["/go/bin/myapp"]