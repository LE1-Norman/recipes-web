<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Установка кодировки
    request.setCharacterEncoding("UTF-8");
    
    // Обработка параметров формы добавления рецепта
    String recipeName = request.getParameter("recipeName");
    String category = request.getParameter("category");
    String cookingTime = request.getParameter("cookingTime");
    String instructions = request.getParameter("instructions");
    String authorName = request.getParameter("authorName");
    
    // Обработка динамических ингредиентов
    String[] ingredientNames = request.getParameterValues("ingredientName");
    String[] ingredientAmounts = request.getParameterValues("ingredientAmount");
    String[] ingredientUnits = request.getParameterValues("ingredientUnit");
    
    // Валидация данных
    List<String> errors = new ArrayList<>();
    
    if (recipeName == null || recipeName.trim().isEmpty()) {
        errors.add("Название рецепта обязательно для заполнения");
    }
    
    if (category == null || category.isEmpty()) {
        errors.add("Необходимо выбрать категорию");
    }
    
    if (cookingTime == null || cookingTime.isEmpty()) {
        errors.add("Время приготовления обязательно");
    }
    
    if (instructions == null || instructions.trim().isEmpty()) {
        errors.add("Инструкция приготовления обязательна");
    }
    
    if (authorName == null || authorName.trim().isEmpty()) {
        errors.add("Имя автора обязательно");
    }
    
    // Проверка ингредиентов
    boolean hasValidIngredients = false;
    if (ingredientNames != null) {
        for (int i = 0; i < ingredientNames.length; i++) {
            if (ingredientNames[i] != null && !ingredientNames[i].trim().isEmpty()) {
                hasValidIngredients = true;
                break;
            }
        }
    }
    
    if (!hasValidIngredients) {
        errors.add("Добавьте хотя бы один ингредиент");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Обработка рецепта - Русская кухня</title>
    <style>
        .container { max-width: 800px; margin: 20px auto; padding: 20px; }
        .success-box { background-color: #d4edda; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .error-box { background-color: #f8d7da; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .recipe-info { background-color: #e9ecef; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .ingredient-list { list-style-type: none; padding: 0; }
        .ingredient-item { background-color: white; padding: 10px; margin-bottom: 5px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📝 Обработка нового рецепта</h1>
        
        <% if (!errors.isEmpty()) { %>
            <div class="error-box">
                <h3>❌ Ошибки при обработке формы:</h3>
                <ul>
                    <% for (String error : errors) { %>
                        <li><%= error %></li>
                    <% } %>
                </ul>
                <p><a href="../forms/add-recipe.jsp">🔄 Вернуться к форме</a></p>
            </div>
        <% } else { %>
            <div class="success-box">
                <h3>✅ Рецепт успешно обработан!</h3>
                <p>Ваш рецепт был получен и готов к сохранению в базе данных.</p>
            </div>
            
            <div class="recipe-info">
                <h3>Информация о рецепте:</h3>
                <p><strong>Название:</strong> <%= recipeName %></p>
                <p><strong>Категория:</strong> 
                    <%
                        switch(category) {
                            case "soup": out.print("Супы"); break;
                            case "main": out.print("Основные блюда"); break;
                            case "salad": out.print("Салаты"); break;
                            case "dessert": out.print("Десерты"); break;
                            default: out.print(category);
                        }
                    %>
                </p>
                <p><strong>Время приготовления:</strong> <%= cookingTime %> минут</p>
                <p><strong>Автор:</strong> <%= authorName %></p>
                
                <h4>Ингредиенты:</h4>
                <ul class="ingredient-list">
                    <%
                        if (ingredientNames != null) {
                            for (int i = 0; i < ingredientNames.length; i++) {
                                if (ingredientNames[i] != null && !ingredientNames[i].trim().isEmpty()) {
                                    String amount = ingredientAmounts != null && i < ingredientAmounts.length ? ingredientAmounts[i] : "";
                                    String unit = ingredientUnits != null && i < ingredientUnits.length ? ingredientUnits[i] : "";
                    %>
                    <li class="ingredient-item">
                        <%= ingredientNames[i] %> - <%= amount %> <%= unit %>
                    </li>
                    <%
                                }
                            }
                        }
                    %>
                </ul>
                
                <h4>Инструкция приготовления:</h4>
                <div style="background-color: white; padding: 15px; border-radius: 3px;">
                    <%= instructions.replace("\n", "<br>") %>
                </div>
            </div>
            
            <div style="margin-top: 20px;">
                <p><strong>Статистика обработки:</strong></p>
                <p>• Получено ингредиентов: <%= ingredientNames != null ? ingredientNames.length : 0 %></p>
                <p>• Длина инструкции: <%= instructions.length() %> символов</p>
                <p>• Время обработки: <%= new java.util.Date() %></p>
            </div>
        <% } %>
        
        <div style="margin-top: 30px;">
            <a href="../forms/add-recipe.jsp">➕ Добавить еще рецепт</a> | 
            <a href="../forms/simple-search.jsp">🔍 Поиск рецептов</a> | 
            <a href="../index.html">🏠 На главную</a>
        </div>
    </div>
</body>
</html>