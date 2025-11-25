<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="russianfood.servlets.RecipesListServlet" %>
<%
    // Получаем количество рецептов из сервлета
    int totalRecipes = RecipesListServlet.getUserRecipeCount();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Рецепт добавлен - Русская кухня</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            max-width: 600px; 
            margin: 50px auto; 
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .success-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            text-align: center;
        }
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        .stats {
            background: #e8f5e8;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
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
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .btn-add { 
            background: linear-gradient(135deg, #2ecc71, #27ae60); 
        }
        .btn-search { 
            background: linear-gradient(135deg, #9b59b6, #8e44ad); 
        }
        .recipe-list {
            margin-top: 20px;
            text-align: left;
        }
        .recipe-item {
            background: #f8f9fa;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            border-left: 4px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✅</div>
        <h1>Рецепт успешно добавлен!</h1>
        <p>Ваш рецепт был сохранен и теперь доступен для поиска.</p>
        
        <div class="stats">
            <h3>📊 Статистика</h3>
            <p>Всего пользовательских рецептов в базе: <strong><%= totalRecipes %></strong></p>
            <p>Спасибо за ваш вклад в нашу коллекцию!</p>
        </div>

        <div class="recipe-list">
            <h3>🎯 Что дальше?</h3>
            <div class="recipe-item">
                <strong>🔍 Поиск рецептов</strong> - Найдите свой рецепт в общем списке
            </div>
            <div class="recipe-item">
                <strong>⭐ Оценка сайта</strong> - Поделитесь вашим мнением о нашем сайте
            </div>
            <div class="recipe-item">
                <strong>➕ Новый рецепт</strong> - Добавьте еще один рецепт
            </div>
        </div>
        
        <div style="margin-top: 30px;">
            <a href="add-recipe.jsp" class="btn btn-add">➕ Добавить еще рецепт</a>
            <a href="simple-search.jsp" class="btn btn-search">🔍 Искать рецепты</a>
            <a href="../index.html" class="btn">🏠 На главную</a>
        </div>

        <div style="margin-top: 20px; font-size: 14px; color: #666;">
            <p>💡 <strong>Совет:</strong> Ваш рецепт теперь отображается в общем списке рецептов 
            с пометкой "⭐" и зеленым фоном.</p>
        </div>
    </div>

    <script>
        // Добавляем небольшую анимацию
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.success-container');
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                container.style.transition = 'all 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>