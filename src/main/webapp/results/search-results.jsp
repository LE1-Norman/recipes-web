<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Установка кодировки для корректного отображения русских символов
    request.setCharacterEncoding("UTF-8");
    
    // Обработка параметров (для GET и POST)
    String userName = request.getParameter("userName");
    String name = request.getParameter("name"); // из GET формы
    String author = request.getParameter("author");
    String time = request.getParameter("time");
    String maxTime = request.getParameter("maxTime");
    String minTime = request.getParameter("minTime");
    String lang = request.getParameter("lang");
    String[] categories = request.getParameterValues("categories");
    String excludeIngredients = request.getParameter("excludeIngredients");
    String difficulty = request.getParameter("difficulty");
    
    // Определяем метод запроса
    String method = request.getMethod();
    
    // Устанавливаем язык сессии
    HttpSession currentSession = request.getSession();
    if (lang != null) {
        currentSession.setAttribute("lang", lang);
    }
    String currentLang = (String) currentSession.getAttribute("lang");
    if (currentLang == null) {
        currentLang = "ru";
    }
    
    // Загружаем ресурсы для интернационализации
    ResourceBundle messages = ResourceBundle.getBundle("messages", new Locale(currentLang));
%>
<!DOCTYPE html>
<html lang='<%= currentLang %>'>
<head>
    <meta charset="UTF-8">
    <title>Результаты поиска - Русская кухня</title>
    <style>
        .results-container { max-width: 800px; margin: 20px auto; padding: 20px; }
        .info-box { background-color: #e3f2fd; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .recipe-item { border: 1px solid #ddd; padding: 15px; margin-bottom: 10px; border-radius: 5px; }
        .param-value { background-color: #f5f5f5; padding: 2px 6px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="results-container">
        <h1>📊 Результаты поиска рецептов</h1>
        
        <div class="info-box">
            <h3>Информация о запросе:</h3>
            <p><strong>Метод:</strong> <span class="param-value"><%= method %></span></p>
            <p><strong>Язык интерфейса:</strong> <span class="param-value"><%= currentLang %></span></p>
        </div>
        
        <div class="info-box">
            <h3>Параметры поиска:</h3>
            <p><strong>Пользователь:</strong> 
               <span class="param-value"><%= userName != null ? userName : (name != null ? name : "Не указан") %></span>
            </p>
            <% if (author != null && !author.isEmpty()) { %>
                <p><strong>Автор:</strong> <span class="param-value"><%= author %></span></p>
            <% } %>
            <% if (time != null || (minTime != null && maxTime != null)) { %>
                <p><strong>Время приготовления:</strong> 
                   <span class="param-value">
                   <% if (minTime != null && maxTime != null) { %>
                       <%= minTime %> - <%= maxTime %> мин
                   <% } else if (time != null) { %>
                       до <%= time %> мин
                   <% } %>
                   </span>
                </p>
            <% } %>
            <% if (categories != null && categories.length > 0) { %>
                <p><strong>Категории:</strong> 
                   <span class="param-value"><%= String.join(", ", categories) %></span>
                </p>
            <% } %>
            <% if (excludeIngredients != null && !excludeIngredients.isEmpty()) { %>
                <p><strong>Исключить:</strong> <span class="param-value"><%= excludeIngredients %></span></p>
            <% } %>
            <% if (difficulty != null && !difficulty.isEmpty()) { %>
                <p><strong>Сложность:</strong> <span class="param-value"><%= difficulty %></span></p>
            <% } %>
        </div>
        
        <h2>Найденные рецепты:</h2>
        
        <!-- Используем ваш существующий сервлет для получения реальных данных -->
        <div style="background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
            <p><strong>Внимание:</strong> Для получения реальных результатов используется ваш сервлет RecipesList</p>
            <p><a href="../RecipesList?name=<%= userName != null ? userName : (name != null ? name : "Шеф") %>&author=<%= author != null ? author : "" %>&time=<%= time != null ? time : "120" %>&lang=<%= currentLang %>">
                🔗 Перейти к реальным результатам через сервлет
            </a></p>
        </div>
        
        <!-- Демонстрационные результаты -->
        <div class="recipe-item">
            <h3>🥘 Борщ</h3>
            <p><strong>Автор:</strong> Иванов И.И.</p>
            <p><strong>Время:</strong> 120 минут</p>
            <p><strong>Категория:</strong> Супы</p>
        </div>
        
        <div class="recipe-item">
            <h3>🥞 Блины</h3>
            <p><strong>Автор:</strong> Петрова А.С.</p>
            <p><strong>Время:</strong> 30 минут</p>
            <p><strong>Категория:</strong> Основные блюда</p>
        </div>
        
        <p style="margin-top: 20px;">
            <a href="../forms/simple-search.jsp">🔍 Новый поиск</a> | 
            <a href="../index.html">🏠 На главную</a>
        </p>
    </div>
</body>
</html>