<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Вход - Русская кухни</title>
    <style>
        body { font-family: Arial; max-width: 400px; margin: 100px auto; padding: 20px; }
        .login-box { border: 1px solid #ccc; padding: 20px; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; }
        .btn { background: #4CAF50; color: white; padding: 10px; border: none; width: 100%; }
        .error { color: red; background: #ffe6e6; padding: 10px; margin-bottom: 15px; }
        .info { color: blue; background: #e3f2fd; padding: 10px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>🍲 Вход в систему</h2>
        
        <% if ("true".equals(request.getParameter("error"))) { %>
            <div class="error">Неверный логин или пароль!</div>
        <% } %>

        <!-- ПРОСТАЯ ФОРМА БЕЗ ИНВАЛИДАЦИИ СЕССИИ -->
        <form method="POST" action="<%= request.getContextPath() %>/j_security_check">
            <div class="form-group">
                <label>Логин:</label>
                <input type="text" name="j_username" required>
            </div>
            <div class="form-group">
                <label>Пароль:</label>
                <input type="password" name="j_password" required>
            </div>
            <input type="submit" value="Войти" class="btn">
        </form>

        <div style="margin-top: 20px; font-size: 14px;">
            <strong>Тестовые пользователи:</strong><br>
            • admin / admin123 (полный доступ)<br>
            • chef / chef123 (добавление рецептов)<br>
            • user / user123 (просмотр рецептов)<br>
            • guest / guest123 (базовый доступ)
        </div>
    </div>

    <script>
        // Очищаем форму при загрузке
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('form').reset();
        });
    </script>
</body>
</html>