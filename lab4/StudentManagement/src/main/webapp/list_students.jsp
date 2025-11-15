<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }
        .message i {
            margin-right: 10px;
            font-size: 1.2em;
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
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a, .pagination strong {
            padding: 8px 12px;
            margin: 0 4px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #007bff;
            border-radius: 5px;
        }
        .pagination strong {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        .table-responsive {
            overflow-x: auto;
        }
        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<h1>📚 Student Management System</h1>

<% if (request.getParameter("message") != null) { %>
<div class="message success">
    <i class="fas fa-check-circle"></i> <%= request.getParameter("message") %>
</div>
<% } %>

<% if (request.getParameter("error") != null) { %>
<div class="message error">
    <i class="fas fa-times-circle"></i> <%= request.getParameter("error") %>
</div>
<% } %>

<a href="add_student.jsp" class="btn">➕ Add New Student</a>

<form action="list_students.jsp" method="GET">
    <input type="text" name="keyword" placeholder="Search by name or code..."
           value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button type="submit" class="btn">Search</button>
    <% if (request.getParameter("keyword") != null && !request.getParameter("keyword").isEmpty()) { %>
    <a href="list_students.jsp" class="btn" style="background-color: #6c757d;">Clear Search</a>
    <% } %>
</form>

<%!
    public int getTotalRecords(Connection conn, String keyword) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalRecords = 0;
        String sql;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql = "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");
            } else {
                sql = "SELECT COUNT(*) FROM students";
                pstmt = conn.prepareStatement(sql);
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                totalRecords = rs.getInt(1);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        return totalRecords;
    }
%>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String keyword = request.getParameter("keyword");
    String sql;
    boolean isSearch = (keyword != null && !keyword.trim().isEmpty());

    String pageParam = request.getParameter("page");
    int currentPage = 1;
    try {
        currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
    } catch (NumberFormatException e) {
        currentPage = 1;
    }

    final int recordsPerPage = 10;
    int totalRecords = 0;
    int totalPages = 0;
    int offset = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/student_management",
                "user1",
                "user1"
        );

        totalRecords = getTotalRecords(conn, keyword);
        totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        if (currentPage <= 0 || totalRecords == 0) {
            currentPage = 1;
        } else if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        offset = (currentPage - 1) * recordsPerPage;


        if (isSearch) {
            sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setInt(3, recordsPerPage);
            pstmt.setInt(4, offset);
        } else {
            sql = "SELECT * FROM students ORDER BY id DESC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordsPerPage);
            pstmt.setInt(2, offset);
        }
        rs = pstmt.executeQuery();
%>
<div class="table-responsive">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Student Code</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Major</th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                int id = rs.getInt("id");
                String studentCode = rs.getString("student_code");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String major = rs.getString("major");
                Timestamp createdAt = rs.getTimestamp("created_at");

                if (isSearch) {
                    String highlightTag = "<span style='background-color: yellow; font-weight: bold; padding: 2px;'>";
                    String endTag = "</span>";
                    try {
                        fullName = fullName.replaceAll("(?i)"+keyword, highlightTag + keyword + endTag);
                        studentCode = studentCode.replaceAll("(?i)"+keyword, highlightTag + keyword + endTag);
                    } catch (Exception e) {
                    }
                }
        %>
        <tr>
            <td><%= id %></td>
            <td><%= studentCode %></td>
            <td><%= fullName %></td>
            <td><%= email != null ? email : "N/A" %></td>
            <td><%= major != null ? major : "N/A" %></td>
            <td><%= createdAt %></td>
            <td>
                <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                <a href="delete_student.jsp?id=<%= id %>"
                   class="action-link delete-link"
                   onclick="return confirm('Are you sure?')">🗑️ Delete</a>
            </td>
        </tr>
        <%
                }
            } catch (ClassNotFoundException e) {
                out.println("<tr><td colspan='7'>Error: JDBC Driver not found!</td></tr>");
                e.printStackTrace();
            } catch (SQLException e) {
                out.println("<tr><td colspan='7'>Database Error: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        </tbody>
    </table>
</div>

<% if (totalPages > 1) {
    String searchParam = (isSearch) ? "&keyword=" + keyword : "";
%>
<div class="pagination">
    <% if (currentPage > 1) { %>
    <a href="list_students.jsp?page=<%= currentPage - 1 %><%= searchParam %>">Previous</a>
    <% } %>

    <%
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) { %>
    <strong><%= i %></strong>
    <% } else { %>
    <a href="list_students.jsp?page=<%= i %><%= searchParam %>"><%= i %></a>
    <% }
    } %>

    <% if (currentPage < totalPages) { %>
    <a href="list_students.jsp?page=<%= currentPage + 1 %><%= searchParam %>">Next</a>
    <% } %>
</div>
<% } %>

<script>
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            msg.style.opacity = '0';
            msg.style.transition = 'opacity 1s ease-out';

            setTimeout(function() {
                msg.style.display = 'none';
            }, 1000);
        });
    }, 3000);
</script>
</body>
</html>