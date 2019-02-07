package main

import (
	"os"
	"fmt"
	"encoding/json"
	"log"
	"github.com/jbogarin/go-cisco-webex-teams/sdk"
	resty "gopkg.in/resty.v1"
	"crypto/tls"
)

var Client *webexteams.Client

type Outrequest struct {
	Source Source `json:"source"`
	Params Params `json:"params"`
}
type Source struct {
	Token   string `json:"token"`
	Email   string `json:"email"`
	RoomID  string `json:"roomid"`
}
type Params struct {
	Text string
}

func main() {
	f, err := os.OpenFile("log", os.O_RDWR | os.O_CREATE | os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("Failed to open logfile: %v", err)
	}
	defer f.Close()

	log.SetOutput(f)
	var request Outrequest
	err = json.NewDecoder(os.Stdin).Decode(&request)
	if err != nil {
		log.Println("Failed to parse input: %s", err)
	}
	log.Println(request.Params.Text, request.Source.Email, request.Source.Token)

	client := resty.New()
	resty.SetTLSClientConfig(&tls.Config{ InsecureSkipVerify: true })
	client.SetAuthToken(request.Source.Token)
	Client = webexteams.NewClient(client)
	message := &webexteams.MessageCreateRequest{
		Markdown:      request.Params.Text,
		ToPersonEmail: request.Source.Email,
		RoomID:        request.Source.RoomID,
	}
	newTextMessage, _, err := Client.Messages.CreateMessage(message)
	if err != nil {
		log.Println("Failed to send notification")
		log.Println("POST:", newTextMessage.ID, newTextMessage.Text, newTextMessage.Created)

	}
	fmt.Println("{\"version\":{\"ref\":\"success\"}}")

}
