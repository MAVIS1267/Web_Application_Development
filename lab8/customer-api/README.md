# Customer API

## Student Information

- **Name:** Mai Long Thiên
- **Student ID:** ITCSIU23059
- **Class:** ITIT23UN41

## API Endpoints

### Base URL

`http://localhost:8080/api/customers`

### Endpoints Implemented

- ✅ GET /api/customers - Get all customers
- ✅ GET /api/customers/{id} - Get by ID
- ✅ POST /api/customers - Create customer
- ✅ PUT /api/customers/{id} - Update customer
- ✅ DELETE /api/customers/{id} - Delete customer
- ✅ GET /api/customers/search?keyword={keyword} - Search
- ✅ GET /api/customers/status/{status} - Filter by status
- ✅ Pagination and sorting
- ✅ PATCH for partial update
- [ ] Bonus features

## How to Run

1. Create database: `customer_management`
2. Update `application.properties` with your MySQL credentials
3. Run: `mvn spring-boot:run`
4. Test: Open Thunder Client or Postman
5. Import collection: `Customer_API.postman_collection.json`

## Testing

All endpoints tested with Thunder Client.
See `screenshots/` folder for test results.

## Features Implemented

- DTO pattern for request/response
- Validation with @Valid
- Exception handling with @RestControllerAdvice
- Custom exceptions (404, 409)
- Proper HTTP status codes
- Search and filter
- Pagination
- Sorting

## Known Issues

- [List any bugs]

## Time Spent

Approximately 3 hours
