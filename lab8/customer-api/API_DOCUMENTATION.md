# Customer API Documentation

## Base URL

`http://localhost:8080/`

## Endpoints

### 1. Get All Customers

**GET** `{{baseURL}}/api/customers?page=0&size=5&sortBy=fullName&sortDir=asc`

**Response:** 200 OK

```json
{
  "totalItems": 5,
  "sortDirection": "asc",
  "totalPages": 1,
  "sortBy": "fullName",
  "customers": [
    {
      "id": 4,
      "customerCode": "C004",
      "fullName": "Alice Brown",
      "email": "alice.brown@example.com",
      "phone": "+1-555-0104",
      "address": "321 Elm St, Houston, TX 77001",
      "status": "INACTIVE",
      "createdAt": "2025-12-06T09:21:44"
    },
    {
      "id": 3,
      "customerCode": "C003",
      "fullName": "Bob Johnson",
      "email": "bob.johnson@example.com",
      "phone": "+1-555-0103",
      "address": "789 Pine Rd, Chicago, IL 60601",
      "status": "ACTIVE",
      "createdAt": "2025-12-06T09:21:44"
    },
    {
      "id": 5,
      "customerCode": "C005",
      "fullName": "Charlie Wilson",
      "email": "charlie.wilson@example.com",
      "phone": "+1-555-0105",
      "address": "654 Maple Dr, Phoenix, AZ 85001",
      "status": "ACTIVE",
      "createdAt": "2025-12-06T09:21:44"
    },
    {
      "id": 2,
      "customerCode": "C002",
      "fullName": "Jane Smith",
      "email": "jane.smith@example.com",
      "phone": "+1-555-0102",
      "address": "456 Oak Ave, Los Angeles, CA 90001",
      "status": "ACTIVE",
      "createdAt": "2025-12-06T09:21:44"
    },
    {
      "id": 1,
      "customerCode": "C001",
      "fullName": "John Updated",
      "email": "john.updated@example.com",
      "phone": "12931215559999",
      "address": "New Address",
      "status": "ACTIVE",
      "createdAt": "2025-12-06T09:21:44"
    }
  ],
  "currentPage": 0
}
```

### 2. Get Customer By ID

**GET** `{{baseURL}}/api/customers/1`

**Response:** 200 OK

```json
{
  "id": 1,
  "customerCode": "C001",
  "fullName": "John Updated",
  "email": "john.updated@example.com",
  "phone": "12931215559999",
  "address": "New Address",
  "status": "ACTIVE",
  "createdAt": "2025-12-06T09:21:44"
}
```

### 3. Create The User

**POST** `{{baseURL}}/api/customers`

**BODY**:

```json
{
  "customerCode": "C1001",
  "fullName": "Nguyen Van A",
  "email": "nguyenvana@example.com",
  "phone": "+84912345678",
  "address": "123 Tran Hung Dao, Q1, HCMC"
}
```

**Response:** 201 Created

```json
{
  "id": 7,
  "customerCode": "C1001",
  "fullName": "Nguyen Van A",
  "email": "nguyenvana@example.com",
  "phone": "+84912345678",
  "address": "123 Tran Hung Dao, Q1, HCMC",
  "status": "ACTIVE",
  "createdAt": "2025-12-12T21:41:47.837637744"
}
```

### 4. Update Customer

**PUT** `{{baseURL}}/api/customers/1`

**BODY**:

```json
{
  "customerCode": "C1001",
  "fullName": "Nguyen Van A Updated",
  "email": "nguyenvana_new@example.com",
  "phone": "+84988888888",
  "address": "456 Le Loi, Q1, HCMC"
}
```

**Response:** 200 OK

```json
{
  "id": 1,
  "customerCode": "C001",
  "fullName": "Nguyen Van A Updated",
  "email": "nguyenvana_new@example.com",
  "phone": "+84988888888",
  "address": "456 Le Loi, Q1, HCMC",
  "status": "ACTIVE",
  "createdAt": "2025-12-06T09:21:44"
}
```

### 5. Partial Update Customer

**PATCH** `{{baseURL}}/api/customers/1`

**BODY**:

```json
{
  "fullName": "Nguyen Van B",
  "phone": "84999999999"
}
```

**Response:** 200 OK

```json
{
  "id": 1,
  "customerCode": "C001",
  "fullName": "Nguyen Van B",
  "email": "nguyenvana_new@example.com",
  "phone": "84999999999",
  "address": "456 Le Loi, Q1, HCMC",
  "status": "ACTIVE",
  "createdAt": "2025-12-06T09:21:44"
}
```

### 6. Delete Customer By ID

**DELETE** `{{baseURL}}/api/customers/1`

**Response:** 200 OK

```json
{
  "message": "Customer deleted successfully"
}
```

### 7. Search Customer

**GET** `{{baseURL}}/api/customers/search?keyword=john`

**Response:** 200 OK

```json
[
  {
    "id": 3,
    "customerCode": "C003",
    "fullName": "Bob Johnson",
    "email": "bob.johnson@example.com",
    "phone": "+1-555-0103",
    "address": "789 Pine Rd, Chicago, IL 60601",
    "status": "ACTIVE",
    "createdAt": "2025-12-06T09:21:44"
  }
]
```

### 8. Filter By Status

**GET** `{{baseURL}}/api/customers/status/INACTIVE`

**Response:** 200 OK

```json
[
  {
    "id": 4,
    "customerCode": "C004",
    "fullName": "Alice Brown",
    "email": "alice.brown@example.com",
    "phone": "+1-555-0104",
    "address": "321 Elm St, Houston, TX 77001",
    "status": "INACTIVE",
    "createdAt": "2025-12-06T09:21:44"
  }
]
```
