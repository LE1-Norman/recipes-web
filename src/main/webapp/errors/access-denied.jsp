<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Доступ запрещен</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f9f9f9;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #d32f2f;
            margin-bottom: 20px;
        }
        .user-info {
            background: #f5f5f5;
            padding: 10px;
            border-radius: 4px;
            margin: 15px 0;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            margin: 10px;
            background: #ff5722;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn-home {
            background: #2196F3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚫 Доступ запрещен</h1>
        <p>У вас нет прав для доступа к этой странице.</p>
        
        <div class="user-info">
            <strong>Текущий пользователь:</strong> 
            <%= request.getRemoteUser() != null ? request.getRemoteUser() : "не аутентифицирован" %>
        </div>
        
        <p>Требуемые права: <strong>admin или chef</strong></p>
        
        <!-- Используем сервлет для смены пользователя -->
        <a href="<%= request.getContextPath() %>/switch-user" class="btn">
            🔓 Выйти и войти под другим пользователем
        </a>
        
        <br>
        
        <a href="<%= request.getContextPath() %>/index.html" class="btn btn-home">
            🏠 На главную
        </a>
    </div>
</body>
</html>