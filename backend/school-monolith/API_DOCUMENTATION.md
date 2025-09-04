# School Management API Documentation

## Multi-School Architecture

This API now supports multiple schools with data isolation. All endpoints that return or modify data now require a `schoolId` parameter to ensure proper data segregation.

## School Management Endpoints

### 1. School Registration
```
POST /api/schools/register
```
Register a new school with admin user.

**Request Body:**
```json
{
  "name": "School Name",
  "schoolCode": "SCHOOL_CODE",
  "address": "School Address",
  "city": "City",
  "state": "State",
  "country": "Country",
  "postalCode": "12345",
  "phone": "+1-555-0123",
  "email": "info@school.com",
  "website": "www.school.com",
  "principalName": "Principal Name",
  "principalPhone": "+1-555-0124",
  "principalEmail": "principal@school.com",
  "adminUsername": "admin",
  "adminFullName": "Admin Full Name",
  "adminEmail": "admin@school.com",
  "adminPhone": "+1-555-0125",
  "adminPassword": "password123"
}
```

### 2. Get All Schools
```
GET /api/schools
```
Get all active schools (for SUPER_ADMIN only).

### 3. Get School by ID
```
GET /api/schools/{id}
```
Get school information by ID.

### 4. Get School by Code
```
GET /api/schools/code/{schoolCode}
```
Get school information by school code.

### 5. Update School
```
PUT /api/schools/{id}
```
Update school information.

### 6. Update School Status
```
PATCH /api/schools/{id}/status?status=ACTIVE
```
Update school status (ACTIVE, INACTIVE, SUSPENDED).

### 7. Delete School
```
DELETE /api/schools/{id}
```
Soft delete a school (marks as INACTIVE).

### 8. Check School Exists
```
GET /api/schools/exists/{schoolCode}
```
Check if a school code already exists.

### 9. Get Schools by Status
```
GET /api/schools/status/{status}
```
Get schools filtered by status.

## Updated Student Endpoints

All student endpoints now support school context:

### 1. Get All Students
```
GET /api/students?schoolId={schoolId}
```
Get all students for a specific school.

### 2. Get Student by ID
```
GET /api/students/{id}?schoolId={schoolId}
```
Get student by ID within school context.

### 3. Get Students by Class
```
GET /api/students/class/{className}?schoolId={schoolId}
```
Get students by class within school context.

### 4. Search Students
```
GET /api/students/search?query={searchTerm}&schoolId={schoolId}
```
Search students within school context.

## Data Models

### SchoolDTO
```java
{
  "id": 1,
  "name": "School Name",
  "schoolCode": "SCHOOL_CODE",
  "address": "Address",
  "city": "City",
  "state": "State",
  "country": "Country",
  "postalCode": "12345",
  "phone": "+1-555-0123",
  "email": "info@school.com",
  "website": "www.school.com",
  "principalName": "Principal Name",
  "principalPhone": "+1-555-0124",
  "principalEmail": "principal@school.com",
  "status": "ACTIVE",
  "createdAt": "2024-01-01T00:00:00",
  "updatedAt": "2024-01-01T00:00:00"
}
```

### Updated DTOs with School Context
All existing DTOs now include a `schoolId` field:
- StudentDTO
- FeeStructureDTO
- PaymentDTO
- StudentFeeDTO
- HomeworkDTO
- UserDTO

## Authentication & Authorization

- **SUPER_ADMIN**: Can access all schools and manage school registration
- **SCHOOL_ADMIN**: Can only access their assigned school
- **TEACHER**: Can only access their assigned school
- **PARENT**: Can only access their assigned school

## School Context

When making API calls, always include the `schoolId` parameter to ensure data isolation:

```
GET /api/students?schoolId=1
GET /api/students/1?schoolId=1
GET /api/students/class/10A?schoolId=1
```

## Error Handling

- **400 Bad Request**: Invalid input data
- **404 Not Found**: School or resource not found
- **403 Forbidden**: Insufficient permissions
- **500 Internal Server Error**: Server-side error

## Testing

Run the test suite to verify multi-school functionality:

```bash
mvn test -Dtest=SchoolServiceTest
```


