# Credit Card API


## Run Tests

```shell
RACK_ENV=test rake db:migrate && ruby spec/credit_card_api_spec.rb
```

### Usage

The base URL of the API is http://creditcardapplicants.herokuapp.com/

Use the following route to access the credit card validation function:

#### Request Path

```
/api/v1/credit_card/validate
```

#### Parameters

| Name          | Value                   |
|:-------------:|:-----------------------:|
| `card_number` | Your credit card number |

#### Response

| Status Code | Body                                         |
|:-----------:|:--------------------------------------------:|
| 200         | JSON with card number and validation result  |
| 400         | `empty`                                      |
