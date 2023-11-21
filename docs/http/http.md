# http.ps1 Function Documentation

The `http.ps1` file in the NoModulePowershell library presents a comprehensive collection of functions crafted to facilitate and streamline the interaction with web APIs and services in PowerShell scripts. These functions are designed to provide a more efficient and less error-prone way of making HTTP requests, ensuring smooth and predictable interactions with web endpoints. This file is specifically designed to accommodate a broad spectrum of HTTP operations, ranging from simple GET requests to fetch data, to more complex POST, PUT, PATCH, and DELETE operations for manipulating web resources. Additionally, it includes utility functions for connection testing, query parameter encoding, and handling response streams, thus offering a robust toolkit for HTTP communication in a PowerShell environment. Each function is engineered to simplify the complexities of web communication, providing clear and concise methods for sending and receiving data over the web.

## List of Functions

1. [Invoke-HttpGetRequest](#invoke-httpgetrequest)
2. [Invoke-HttpPostRequest](#invoke-httppostrequest)
3. [Invoke-HttpPutRequest](#invoke-httpputrequest)
4. [Invoke-HttpDeleteRequest](#invoke-httpdeleterequest)
5. [Invoke-HttpPatchRequest](#invoke-httppatchrequest)
6. (todo) [Test-HttpConnection](#test-httpconnection)
7. (todo) [ConvertTo-HttpQueryParameters](#convertto-httpqueryparameters)
8. (todo) [Receive-HttpResponseStream](#receive-httpresponsestream)

---

## Invoke-HttpGetRequest

Sends a HTTP GET request to a specified URL. This function is used to retrieve data from APIs or web services by making GET requests.

| Argument | Type     | Mandatory | Description                                   | Example Value                           |
|----------|----------|-----------|-----------------------------------------------|-----------------------------------------|
| Url      | string   | Yes       | The URL to which the GET request will be sent | `'http://example.com/api/data'`         |
| Headers  | hashtable| No        | Optional headers for the GET request          | `@{ "Authorization" = "Bearer your_token" }` |

Usage:

To send a simple GET request:

```powershell
$response = Invoke-HttpGetRequest -Url "http://example.com/api/data"
```

To send a GET request with custom headers:

```powershell
$headers = @{ "Authorization" = "Bearer your_token" }
$response = Invoke-HttpGetRequest -Url "http://example.com/api/data" -Headers $headers
```

---

## Invoke-HttpPostRequest

Sends a HTTP POST request to a specified URL. This function is used for submitting data to APIs or web services in a specific format.

| Argument | Type      | Mandatory | Description                                  | Example Value                                          |
|----------|-----------|-----------|----------------------------------------------|--------------------------------------------------------|
| Url      | string    | Yes       | The URL to which the POST request will be sent | `'http://example.com/api/users'`                      |
| Body     | string    | Yes       | The string data to be sent in the POST request | `'{"name":"John", "email":"john@example.com"}'`       |
| Headers  | hashtable | No        | Optional headers for the POST request       | `@{ "Content-Type" = "application/json" }`             |

Usage:

To send a POST request with JSON data:

```powershell
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPostRequest -Url "http://example.com/api/users" -Body $data
```

To send a POST request with JSON data and custom headers:

```powershell
$headers = @{ "Content-Type" = "application/json" }
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPostRequest -Url "http://example.com/api/users" -Body $data -Headers $headers
```

---

## Invoke-HttpPutRequest

Sends a HTTP PUT request to a specified URL. This function is used for updating resources or data on APIs or web services.

| Argument | Type      | Mandatory | Description                                  | Example Value                                          |
|----------|-----------|-----------|----------------------------------------------|--------------------------------------------------------|
| Url      | string    | Yes       | The URL to which the PUT request will be sent | `'http://example.com/api/users/1'`                     |
| Body     | string    | Yes       | The string data to be sent in the PUT request | `'{"name":"John", "email":"john@example.com"}'`        |
| Headers  | hashtable | No        | Optional headers for the PUT request         | `@{ "Content-Type" = "application/json" }`             |

Usage:

To send a PUT request with JSON data:

```powershell
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPutRequest -Url "http://example.com/api/users/1" -Body $data
```

To send a PUT request with JSON data and custom headers:

```powershell
$headers = @{ "Content-Type" = "application/json" }
$data = @{name="John"; email="john@example.com"} | ConvertTo-Json
$response = Invoke-HttpPutRequest -Url "http://example.com/api/users/1" -Body $data -Headers $headers
```

---

## Invoke-HttpDeleteRequest

Sends a HTTP DELETE request to a specified URL. This function is used for deleting resources or data on APIs or web services.

| Argument | Type      | Mandatory | Description                                   | Example Value                                 |
|----------|-----------|-----------|-----------------------------------------------|-----------------------------------------------|
| Url      | string    | Yes       | The URL to which the DELETE request will be sent | `'http://example.com/api/users/1'`           |
| Headers  | hashtable | No        | Optional headers for the DELETE request      | `@{ "Authorization" = "Bearer your_token" }` |

Usage:

To send a simple DELETE request:

```powershell
$response = Invoke-HttpDeleteRequest -Url "http://example.com/api/users/1"
```

To send a DELETE request with custom headers:

```powershell
$headers = @{ "Authorization" = "Bearer your_token" }
$response = Invoke-HttpDeleteRequest -Url "http://example.com/api/users/1" -Headers $headers
```

---

## Invoke-HttpPatchRequest

Sends a HTTP PATCH request to a specified URL. This function is used for applying partial updates to resources on APIs or web services.

| Argument | Type      | Mandatory | Description                                  | Example Value                                          |
|----------|-----------|-----------|----------------------------------------------|--------------------------------------------------------|
| Url      | string    | Yes       | The URL to which the PATCH request will be sent | `'http://example.com/api/users/1'`                     |
| Body     | string    | Yes       | The string data to be sent in the PATCH request | `'{"email":"john_updated@example.com"}'`               |
| Headers  | hashtable | No        | Optional headers for the PATCH request       | `@{ "Content-Type" = "application/json" }`             |

Usage:

To send a PATCH request with JSON data:

```powershell
$data = @{email="john_updated@example.com"} | ConvertTo-Json
$response = Invoke-HttpPatchRequest -Url "http://example.com/api/users/1" -Body $data
```

To send a PATCH request with JSON data and custom headers:

```powershell
$headers = @{ "Content-Type" = "application/json" }
$data = @{email="john_updated@example.com"} | ConvertTo-Json
$response = Invoke-HttpPatchRequest -Url "http://example.com/api/users/1" -Body $data -Headers $headers
```


---

<p align="right">
  <a href="/docs/README.md">← Go Back</a>
</p>