package main

import (
    "context"
    "database/sql"
    "encoding/json"
    "fmt"
    "log"
    "os"

    _ "github.com/lib/pq"

	"github.com/aws/aws-lambda-go/lambda"
    "github.com/cyberark/conjur-api-go/conjurapi"
    "github.com/cyberark/conjur-api-go/conjurapi/authn"
)

type Food struct {
    ID        int
    FoodName  string
    Calories  int
    Protein   int
    Carbs     int
    Fat       int
    Fiber     int
    Vitamins  int
    Minerals  int
}

type MyEvent struct {
	Name string `json:"name"`
}

func GetConjurClient() (*conjurapi.Client, error) {
	config, err := conjurapi.LoadConfig()
	if err != nil {
		return nil, err
	}

	conjur, err := conjurapi.NewClientFromKey(config,
		authn.LoginPair{
			Login:  os.Getenv("CONJUR_AUTHN_LOGIN"),
			APIKey: os.Getenv("CONJUR_AUTHN_API_KEY"),
		},
	)
	if err != nil {
		return nil, err
	}

	return conjur, nil
}

func RetrieveSecret(conjur *conjurapi.Client, variableIdentifier string) ([]byte, error) {
	// Retrieve a secret into []byte.
	secretValue, err := conjur.RetrieveSecret(variableIdentifier)
	if err != nil {
		return nil, err
	}

	return secretValue, nil
}

func query() (string) {
    // Open a connection to the database
    // Get environment variables
    dbPort := os.Getenv("PORT")

    conjur, err := GetConjurClient()
	if err != nil {
        panic(err)
	}

    secretValue, err := RetrieveSecret(conjur, "blueOrchidApplication/dbUrl")
    if err != nil {
        panic(err)
    }
    dbHost := string(secretValue)

	secretValue, err = RetrieveSecret(conjur, "blueOrchidApplication/dbUsername")
    if err != nil {
        panic(err)
    }
    dbUser := string(secretValue)

	secretValue, err = RetrieveSecret(conjur, "blueOrchidApplication/dbPassword")
    if err != nil {
        panic(err)
    }
    dbPass := string(secretValue)

    // Open a connection to the database
	connect := fmt.Sprintf("host=%s port=%s user=%s password=%s sslmode=require", dbHost, dbPort, dbUser, dbPass)
	log.Printf("Connecting to %s", connect)

    db, err := sql.Open("postgres", connect)
    if err != nil {
        log.Fatal("Failed to open DB connection: ", err)
    }
    defer db.Close()

    // Query the database for all foods
    rows, err := db.Query("SELECT * FROM nutrition")
    if err != nil {
        log.Fatal(err)
    }
    defer rows.Close()

    // Iterate over the results and create a slice of Food structs
    var foods []Food
    for rows.Next() {
        var food Food
        err := rows.Scan(&food.ID, &food.FoodName, &food.Calories, &food.Protein, &food.Carbs, &food.Fat, &food.Fiber, &food.Vitamins, &food.Minerals)
        if err != nil {
            log.Fatal(err)
        }
        foods = append(foods, food)
    }
    if err := rows.Err(); err != nil {
        log.Fatal(err)
    }

    data, err := json.MarshalIndent(foods, "", "  ")
    return string(data)
}

func handleRequest(ctx context.Context, name MyEvent) (string, error) {
	return fmt.Sprintf("Query results:\n%s", query()), nil
}

func main() {
	lambda.Start(handleRequest)
}