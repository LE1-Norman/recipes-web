<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Простой поиск рецептов - Русская кухня</title>
    <style>
        .form-container {
            max-width: 500px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>🔍 Поиск рецептов</h1>
        
        <!-- ИСПРАВЛЕННАЯ ФОРМА - отправляет на сервлет RecipesList -->
        <form method="GET" action="${pageContext.request.contextPath}/RecipesList">
            
            <div class="form-group">
                <label for="name">Ваше имя:</label>
                <input type="text" id="name" name="name" 
                       placeholder="Введите ваше имя" value="Гость">
            </div>
            
            <div class="form-group">
                <label for="author">Автор рецепта:</label>
                <select id="author" name="author">
                    <option value="">Все авторы</option>
                    <option value="Иванов И.И.">Иванов И.И.</option>
                    <option value="Петрова А.С.">Петрова А.С.</option>
                    <option value="Сидоров В.П.">Сидоров В.П.</option>
                    <option value="Кузнецова О.И.">Кузнецова О.И.</option>
                </select>
            </div>
            
            <div class="form-group">
    			<label>Макс. время приготовления: <span id="timeValue">60 мин</span></label>
    			<input type="range" id="cookingTimeRange" name="time" 
          			   min="10" max="240" value="60" step="5"
           			   oninput="document.getElementById('timeValue').textContent = this.value + ' мин'">
			</div>
            
            <div class="form-group">
                <label for="lang">Язык интерфейса:</label>
                <select id="lang" name="lang">
                    <option value="ru">Русский</option>
                    <option value="en">English</option>
                </select>
            </div>
            
            <input type="submit" value="Найти рецепты" class="btn">
        </form>
        
        <div style="margin-top: 20px;">
            <h3>Примеры быстрого поиска:</h3>
            <a href="${pageContext.request.contextPath}/RecipesList?name=Гость&time=30">Быстрые рецепты (до 30 мин)</a><br>
            <a href="${pageContext.request.contextPath}/RecipesList?name=Шеф&author=Иванов И.И.">Рецепты от Иванова</a><br>
            <a href="${pageContext.request.contextPath}/RecipesList?name=Повар&time=60&lang=en">Рецепты до 1 часа (English)</a>
        </div>
        
        <p style="margin-top: 20px;">
            <a href="advanced-search.jsp">➡️ Перейти к расширенному поиску</a><br>
            <a href="add-recipe.jsp">➡️ Добавить новый рецепт</a><br>
            <a href="../index.html">🏠 На главную</a>
        </p>
    </div>
</body>
</html>