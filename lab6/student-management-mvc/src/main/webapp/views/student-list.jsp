<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }

        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        th a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        th a:hover {
            text-decoration: underline;
            opacity: 0.9;
        }

        tbody tr {
            transition: background-color 0.2s;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box form, .filter-box form {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar h2 {
            font-size: 20px;
        }

        .navbar {
            background: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-logout:hover {
            background: #c0392b;
        }

        .btn-logout {
            padding: 8px 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            transition: background 0.3s;
        }

        .role-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .role-admin {
            background: #e74c3c;
        }

        .role-user {
            background: #3498db;
        }

        .btn-nav {
            padding: 8px 20px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            transition: background 0.3s;
        }

        .filter-select { width: 200px; }
    </style>
</head>
<body>
<div class="navbar">
    <h2>📚 Student Management System</h2>
    <div class="navbar-right">
        <div class="user-info">
            <span>Welcome, ${sessionScope.fullName}</span>
            <span class="role-badge role-${sessionScope.role}">
                ${sessionScope.role}
            </span>
        </div>
        <a href="dashboard" class="btn-nav">Dashboard</a>
        <a href="logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="container">
    <h1>📚 Student Management System</h1>
    <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

    <!-- Success Message -->
    <c:if test="${not empty param.message}">
        <div class="message success">
            ✅ ${param.message}
        </div>
    </c:if>

    <!-- Error Message -->
    <c:if test="${not empty param.error}">
        <div class="message error">
            ❌ ${param.error}
        </div>
    </c:if>

    <!-- Toolbar -->
    <div class="toolbar">
        <c:if test="${sessionScope.role eq 'admin'}">
            <div style="margin: 20px 0;">
                <a href="student?action=new" class="btn btn-primary">➕ Add New Student</a>
            </div>
        </c:if>

        <div style="display: flex; gap: 15px; flex-wrap: wrap;">
            <div class="filter-box">
                <form action="student" method="get">
                    <input type="hidden" name="action" value="filter">
                    <select name="major" class="filter-select" onchange="this.form.submit()">
                        <option value="">All Majors</option>
                        <option value="Computer Science" ${currentMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                        <option value="Information Technology" ${currentMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                        <option value="Software Engineering" ${currentMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                        <option value="Business Administration" ${currentMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                    </select>
                    <button type="submit" class="btn btn-secondary">Filter</button>
                    <c:if test="${not empty currentMajor}">
                        <a href="student?action=list" class="btn btn-outline">Clear</a>
                    </c:if>
                </form>
            </div>
            <div class="search-box">
                <form action="student" method="get">
                    <input type="hidden" name="action" value="search">
                    <input type="text"
                           name="keyword"
                           class="search-input"
                           value="${keyword}"
                           placeholder="Search by name or email...">
                    <button type="submit" class="btn btn-secondary">🔍</button>
                    <c:if test="${not empty keyword}">
                        <a href="student?action=list" class="btn btn-outline">Clear</a>
                    </c:if>
                </form>
            </div>
        </div>
    </div>

    <!-- Search Feedback Message -->
    <c:if test="${not empty keyword}">
        <div class="message info">
            Search results for: <strong>${keyword}</strong>
        </div>
    </c:if>

    <!-- Student Table -->
    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                <tr>
                    <!-- ID Column Sort -->
                    <th>
                        <c:set var="newOrder" value="${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}" />
                        <a href="student?action=sort&sortBy=id&order=${newOrder}">
                            ID <c:if test="${sortBy == 'id'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>

                    <!-- Code Column Sort -->
                    <th>
                        <c:set var="newOrder" value="${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}" />
                        <a href="student?action=sort&sortBy=student_code&order=${newOrder}">
                            Student Code <c:if test="${sortBy == 'student_code'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>

                    <!-- Name Column Sort -->
                    <th>
                        <c:set var="newOrder" value="${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}" />
                        <a href="student?action=sort&sortBy=full_name&order=${newOrder}">
                            Full Name <c:if test="${sortBy == 'full_name'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>

                    <!-- Email Column Sort -->
                    <th>
                        <c:set var="newOrder" value="${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}" />
                        <a href="student?action=sort&sortBy=email&order=${newOrder}">
                            Email <c:if test="${sortBy == 'email'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>

                    <!-- Major Column Sort -->
                    <th>
                        <c:set var="newOrder" value="${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}" />
                        <a href="student?action=sort&sortBy=major&order=${newOrder}">
                            Major <c:if test="${sortBy == 'major'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>

                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="student" items="${students}">
                    <tr>
                        <td>${student.id}</td>
                        <td><strong>${student.studentCode}</strong></td>
                        <td>${student.fullName}</td>
                        <td>${student.email}</td>
                        <td>${student.major}</td>
                        <td>
                            <div class="actions">
                                <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                    ✏️ Edit
                                </a>
                                <a href="student?action=delete&id=${student.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this student?')">
                                    🗑️ Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <h3>No students found</h3>
                <c:if test="${not empty currentMajor}">
                    <p>Current filter: <strong>${currentMajor}</strong>. <a href="student?action=list">Clear filter</a></p>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
