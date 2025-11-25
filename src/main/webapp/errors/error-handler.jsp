<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%
    // Получаем информацию об ошибке из request attributes
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
    String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
    String servletName = (String) request.getAttribute("jakarta.servlet.error.servlet_name");
    Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
    
    // Устанавливаем значения по умолчанию
    if (statusCode == null) statusCode = 500;
    if (errorMessage == null) errorMessage = "Неизвестная ошибка";
    if (requestUri == null) requestUri = request.getRequestURI();
    if (servletName == null) servletName = "Неизвестный сервлет";
    
    // Определяем тип ошибки для отображения
    String errorTitle = "Произошла ошибка";
    String errorDescription = "При обработке вашего запроса возникла ошибка. Пожалуйста, попробуйте еще раз.";
    String errorIcon = "⚠️";
    
    switch (statusCode) {
        case 404:
            errorTitle = "Страница не найдена";
            errorDescription = "Запрашиваемая страница не существует или была перемещена.";
            errorIcon = "🔍";
            break;
        case 500:
            errorTitle = "Внутренняя ошибка сервера";
            errorDescription = "На сервере произошла непредвиденная ошибка.";
            errorIcon = "⚙️";
            break;
        case 403:
            errorTitle = "Доступ запрещен";
            errorDescription = "У вас нет прав для доступа к этой странице.";
            errorIcon = "🚫";
            break;
        case 400:
            errorTitle = "Неверный запрос";
            errorDescription = "Сервер не может обработать ваш запрос.";
            errorIcon = "❌";
            break;
    }
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Ошибка <%= statusCode %> - Русская кухня</title>
    <style>
        body { 
            font-family: 'Arial', sans-serif; 
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            background: white;
            max-width: 700px;
            width: 100%;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
        }
        .error-icon { 
            font-size: 80px; 
            margin-bottom: 20px;
        }
        .error-code {
            font-size: 48px;
            font-weight: bold;
            color: #e74c3c;
            margin: 10px 0;
        }
        .error-title {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        .error-description {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .error-details {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            text-align: left;
            border-left: 4px solid #e74c3c;
        }
        .error-details h3 {
            color: #2c3e50;
            margin-top: 0;
            margin-bottom: 15px;
        }
        .error-details p {
            margin: 8px 0;
            font-size: 14px;
        }
        .error-details strong {
            color: #34495e;
        }
        .btn-group {
            margin: 30px 0;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 8px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .btn-home { background: linear-gradient(135deg, #2ecc71, #27ae60); }
        .btn-search { background: linear-gradient(135deg, #9b59b6, #8e44ad); }
        .btn-back { background: linear-gradient(135deg, #95a5a6, #7f8c8d); }
        .btn-contact { background: linear-gradient(135deg, #e67e22, #d35400); }
        
        .suggestions {
            background: #e8f4fd;
            padding: 20px;
            border-radius: 10px;
            margin-top: 25px;
            text-align: left;
        }
        .suggestions h3 {
            color: #2980b9;
            margin-top: 0;
        }
        .suggestions ul {
            padding-left: 20px;
            margin-bottom: 0;
        }
        .suggestions li {
            margin: 8px 0;
        }
        .suggestions a {
            color: #3498db;
            text-decoration: none;
        }
        .suggestions a:hover {
            text-decoration: underline;
        }
        
        .tech-info {
            font-size: 12px;
            color: #95a5a6;
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #ecf0f1;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            .error-container {
                padding: 20px;
            }
            .btn {
                display: block;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon"><%= errorIcon %></div>
        <div class="error-code"><%= statusCode %></div>
        <h1 class="error-title"><%= errorTitle %></h1>
        <p class="error-description"><%= errorDescription %></p>
        
        <div class="error-details">
            <h3>📋 Детали ошибки:</h3>
            <p><strong>Код ошибки:</strong> <%= statusCode %></p>
            <p><strong>Сообщение:</strong> <%= errorMessage %></p>
            <p><strong>Запрошенный URL:</strong> <%= requestUri %></p>
            <p><strong>Сервлет:</strong> <%= servletName %></p>
            <p><strong>Метод запроса:</strong> <%= request.getMethod() %></p>
            <p><strong>Время ошибки:</strong> <%= new java.util.Date() %></p>
            
            <% if (throwable != null) { %>
                <p><strong>Тип исключения:</strong> <%= throwable.getClass().getName() %></p>
                <% if (throwable.getMessage() != null) { %>
                    <p><strong>Сообщение исключения:</strong> <%= throwable.getMessage() %></p>
                <% } %>
            <% } %>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">🏠 На главную</a>
            <a href="${pageContext.request.contextPath}/forms/simple-search.jsp" class="btn btn-search">🔍 Поиск рецептов</a>
            <a href="javascript:history.back()" class="btn btn-back">↩️ Назад</a>
            <a href="javascript:location.reload()" class="btn">🔄 Обновить</a>
        </div>

        <% if (statusCode == 404) { %>
        <div class="suggestions">
            <h3>💡 Возможно, вы искали:</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/forms/simple-search.jsp">🔍 Простой поиск рецептов</a></li>
                <li><a href="${pageContext.request.contextPath}/forms/rating-form.jsp">⭐ Оценка сайта</a></li>
                <li><a href="${pageContext.request.contextPath}/forms/add-recipe.jsp">➕ Добавить рецепт</a></li>
                <li><a href="${pageContext.request.contextPath}/RecipesList">📄 Список всех рецептов</a></li>
            </ul>
        </div>
        <% } %>
        
        <div class="tech-info">
            <p><strong>Техническая информация:</strong></p>
            <p>Session ID: <%= session.getId().substring(0, 10) %>... | 
               Server: <%= application.getServerInfo() %> | 
               Context Path: <%= request.getContextPath() %></p>
        </div>
    </div>

    <script>
        // Добавляем анимацию появления
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.error-container');
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                container.style.transition = 'all 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
            }, 100);
        });
        
        // Логирование ошибки в консоль для разработчиков
        console.error('HTTP <%= statusCode %>: <%= errorTitle %>', {
            url: '<%= requestUri %>',
            message: '<%= errorMessage %>',
            timestamp: '<%= new java.util.Date() %>'
        });
    </script>
</body>
</html>