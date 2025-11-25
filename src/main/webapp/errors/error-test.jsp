<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="error-handler.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Тест ошибок - Русская кухня</title>
</head>
<body>
    <div style="max-width: 600px; margin: 50px auto; padding: 20px;">
        <h1>🧪 Тестирование обработки ошибок</h1>
        <p>Эта страница демонстрирует различные сценарии ошибок в JSP.</p>
        
        <div style="margin: 20px 0;">
            <h3>Выберите тип ошибки для тестирования:</h3>
            
            <div style="display: flex; gap: 10px; flex-wrap: wrap; margin: 20px 0;">
                <a href="error-test.jsp?type=arithmetic" style="padding: 10px 15px; background-color: #dc3545; color: white; text-decoration: none; border-radius: 5px;">
                    🧮 Арифметическая ошибка
                </a>
                <a href="error-test.jsp?type=nullpointer" style="padding: 10px 15px; background-color: #fd7e14; color: white; text-decoration: none; border-radius: 5px;">
                    📌 Null Pointer Exception
                </a>
                <a href="error-test.jsp?type=array" style="padding: 10px 15px; background-color: #6f42c1; color: white; text-decoration: none; border-radius: 5px;">
                    📊 Выход за границы массива
                </a>
                <a href="error-test.jsp?type=custom" style="padding: 10px 15px; background-color: #20c997; color: white; text-decoration: none; border-radius: 5px;">
                    🎯 Пользовательская ошибка
                </a>
            </div>
        </div>

        <%
            String errorType = request.getParameter("type");
            
            if (errorType != null) {
                switch (errorType) {
                    case "arithmetic":
                        // Деление на ноль
                        int result = 10 / 0;
                        break;
                    case "nullpointer":
                        // Null Pointer Exception
                        String nullString = null;
                        int length = nullString.length();
                        break;
                    case "array":
                        // ArrayIndexOutOfBounds
                        int[] array = new int[5];
                        int value = array[10];
                        break;
                    case "custom":
                        // Пользовательское исключение
                        throw new ServletException("Это тестовая пользовательская ошибка");
                }
            }
        %>
        
        <% if (errorType == null) { %>
            <div style="background-color: #d1ecf1; padding: 15px; border-radius: 5px;">
                <h4>ℹ️ Информация о тестировании:</h4>
                <p>Каждая кнопка генерирует определенный тип исключения, который обрабатывается страницей <code>error-handler.jsp</code>.</p>
                <p>Это демонстрирует механизм обработки ошибок в JSP с использованием директивы <code>errorPage</code>.</p>
            </div>
        <% } %>
        
        <div style="margin-top: 30px;">
            <a href="../index.html" style="padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px;">🏠 На главную</a>
            <a href="../forms/simple-search.jsp" style="padding: 10px 15px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px;">🔍 К формам</a>
        </div>
    </div>
</body>
</html>