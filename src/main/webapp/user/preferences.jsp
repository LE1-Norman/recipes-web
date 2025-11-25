<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    // Получаем текущие настройки из cookie
    String currentColor = "theme-blue";
    String currentName = "";
    
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("userColor".equals(cookie.getName())) {
                currentColor = cookie.getValue();
            }
            if ("userName".equals(cookie.getName())) {
                currentName = cookie.getValue();
            }
        }
    }
    
    // Получаем статистику из сессии
    Integer visitCount = (Integer) session.getAttribute("visitCount");
    String lastVisit = (String) session.getAttribute("lastVisit");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Настройки пользователя - Русская кухня</title>
    <style>
        body { 
            font-family: Arial; 
            max-width: 600px; 
            margin: 50px auto; 
            padding: 20px; 
            transition: all 0.3s ease;
        }
        
        /* Темы цветов */
        .theme-blue { background-color: #e3f2fd; color: #1565c0; }
        .theme-blue .prefs-box { border: 2px solid #2196F3; background: white; }
        .theme-blue .btn { background: #2196F3; }
        
        .theme-green { background-color: #e8f5e9; color: #2e7d32; }
        .theme-green .prefs-box { border: 2px solid #4CAF50; background: white; }
        .theme-green .btn { background: #4CAF50; }
        
        .theme-orange { background-color: #fff3e0; color: #ef6c00; }
        .theme-orange .prefs-box { border: 2px solid #FF9800; background: white; }
        .theme-orange .btn { background: #FF9800; }
        
        .theme-purple { background-color: #f3e5f5; color: #7b1fa2; }
        .theme-purple .prefs-box { border: 2px solid #9C27B0; background: white; }
        .theme-purple .btn { background: #9C27B0; }
        
        .prefs-box { 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .form-group { 
            margin-bottom: 20px; 
        }
        
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: bold;
        }
        
        input[type="text"], select { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 5px; 
            font-size: 16px;
        }
        
        .btn { 
            background: #4CAF50; 
            color: white; 
            padding: 12px 24px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            font-size: 16px;
            margin-right: 10px;
        }
        
        .btn:hover { opacity: 0.9; }
        
        .stats { 
            background: #f5f5f5; 
            padding: 15px; 
            border-radius: 5px; 
            margin: 20px 0; 
        }
        
        .success { 
            color: green; 
            background: #e8f5e9; 
            padding: 10px; 
            border-radius: 5px; 
            margin-bottom: 20px;
        }
        
        .theme-preview {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid #fff;
        }
    </style>
</head>
<body class="<%= currentColor %>">
    <div class="prefs-box">
        <h2>🎨 Настройки пользователя</h2>
        
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="success">✅ Настройки успешно сохранены!</div>
        <% } %>
        
        <!-- Статистика посещений -->
        <div class="stats">
            <h3>📊 Ваша статистика</h3>
            <p><strong>Количество посещений:</strong> <%= visitCount != null ? visitCount : 1 %></p>
            <p><strong>Последний визит:</strong> <%= lastVisit != null ? lastVisit : "Первый визит" %></p>
            <p><strong>Текущий пользователь:</strong> <%= request.getRemoteUser() != null ? request.getRemoteUser() : "Гость" %></p>
        </div>
        
        <!-- Форма настроек -->
        <form method="POST" action="<%= request.getContextPath() %>/user/preferences">
            <div class="form-group">
                <label for="userName">📝 Ваше имя для приветствий:</label>
                <input type="text" id="userName" name="userName" 
                       value="<%= currentName %>" 
                       placeholder="Введите ваше имя">
            </div>
            
            <div class="form-group">
                <label for="userColor">🎨 Цветовая тема:</label>
                <select id="userColor" name="userColor">
                    <option value="theme-blue" <%= "theme-blue".equals(currentColor) ? "selected" : "" %>>
                        🔵 Синяя тема
                    </option>
                    <option value="theme-green" <%= "theme-green".equals(currentColor) ? "selected" : "" %>>
                        🟢 Зеленая тема
                    </option>
                    <option value="theme-orange" <%= "theme-orange".equals(currentColor) ? "selected" : "" %>>
                        🟠 Оранжевая тема
                    </option>
                    <option value="theme-purple" <%= "theme-purple".equals(currentColor) ? "selected" : "" %>>
                        🟣 Фиолетовая тема
                    </option>
                </select>
            </div>
            
            <button type="submit" class="btn">💾 Сохранить настройки</button>
            <a href="<%= request.getContextPath() %>/index.html" class="btn" style="background: #6c757d;">🏠 На главную</a>
        </form>
    </div>
    
    <script>
        // Динамическое изменение темы при выборе
        document.getElementById('userColor').addEventListener('change', function() {
            document.body.className = this.value;
        });
    </script>
</body>
</html>