<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Умный поиск рецептов - Русская кухня</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .search-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .search-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .search-input-group {
            position: relative;
            margin-bottom: 20px;
        }
        
        .search-input {
            width: 95%;
            padding: 15px 20px;
            font-size: 16px;
            border: 2px solid #ddd;
            border-radius: 25px;
            outline: none;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            border-color: #4CAF50;
        }
        
        .search-button {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            margin-right: 10px;
            transition: transform 0.2s;
        }
        
        .search-button:hover {
            transform: translateY(-2px);
        }
        
        .clear-button {
            background: #f44336;
            color: white;
            border: none;
            padding: 15px 20px;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .clear-button:hover {
            transform: translateY(-2px);
        }
        
        .suggestions-container {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            z-index: 1000;
            display: none;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .suggestion-item {
            padding: 12px 20px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.2s;
        }
        
        .suggestion-item:hover {
            background-color: #f8f9fa;
        }
        
        .suggestion-item:last-child {
            border-bottom: none;
        }
        
        .suggestion-name {
            font-weight: bold;
            color: #333;
        }
        
        .suggestion-desc {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }
        
        .filters-container {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        
        .filter-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        
        .filter-select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: white;
        }
        
        .results-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            min-height: 200px;
        }
        
        .loading-spinner {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #4CAF50;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .recipe-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            background: #fafafa;
            transition: transform 0.2s;
        }
        
        .recipe-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .recipe-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .recipe-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            font-size: 14px;
            color: #666;
        }
        
        .recipe-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .recipe-ingredients {
            font-size: 14px;
            color: #555;
            line-height: 1.4;
        }
        
        .user-recipe-badge {
            background: #4CAF50;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
        }
        
        .navigation {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .nav-link {
            display: inline-block;
            margin: 0 10px;
            padding: 10px 20px;
            background: #2196F3;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .nav-link:hover {
            background: #1976D2;
        }
    </style>
</head>
<body>
    <%
    // Получаем имя пользователя из cookie
    String userName = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("userName".equals(cookie.getName())) {
                userName = cookie.getValue();
            }
        }
    }
    %>

    <!-- Приветственная панель -->
    <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 20px; border: 1px solid #ddd;">
        <strong>👋 Привет, <%= !userName.isEmpty() ? userName : request.getRemoteUser() %>!</strong>
        | <a href="<%= request.getContextPath() %>/user/preferences.jsp">🎨 Настройки</a>
        | <a href="<%= request.getContextPath() %>/switch-user">🔐 Сменить пользователя</a>
        | <a href="<%= request.getContextPath() %>/forms/simple-search.jsp">📋 Обычный поиск</a>
    </div>

    <div class="search-container">
        <div class="search-header">
            <h1>🔍 Умный поиск рецептов</h1>
            <p>Находите рецепты мгновенно с автодополнением и фильтрацией</p>
        </div>

        <!-- Форма поиска -->
        <div class="search-input-group">
            <input type="text" 
                   id="searchInput" 
                   class="search-input" 
                   placeholder="Введите название рецепта или ингредиент..."
                   autocomplete="off">
            <div id="suggestions" class="suggestions-container"></div>
        </div>

        <!-- Фильтры -->
        <div class="filters-container">
            <div class="filter-group">
                <label class="filter-label">🍽️ Категория:</label>
                <select id="categoryFilter" class="filter-select">
                    <option value="">Все категории</option>
                    <option value="main">Основные блюда</option>
                    <option value="soup">Супы</option>
                    <option value="salad">Салаты</option>
                    <option value="dessert">Десерты</option>
                    <option value="drink">Напитки</option>
                    <option value="bakery">Выпечка</option>
                    <option value="snack">Закуски</option>
                </select>
            </div>
            
            <div class="filter-group">
                <label class="filter-label">⏱️ Макс. время (мин):</label>
                <select id="timeFilter" class="filter-select">
                    <option value="">Любое время</option>
                    <option value="30">До 30 минут</option>
                    <option value="60">До 1 часа</option>
                    <option value="120">До 2 часов</option>
                    <option value="180">До 3 часов</option>
                </select>
            </div>
        </div>

        <!-- Кнопки управления -->
        <div style="text-align: center;">
            <button id="searchButton" class="search-button">🎯 Найти рецепты</button>
            <button id="clearButton" class="clear-button">🧹 Очистить</button>
        </div>
    </div>

    <!-- Контейнер для результатов -->
    <div class="results-container">
        <div id="resultsContent">
            <div class="no-results">
                <h3>🔍 Начните поиск</h3>
                <p>Введите название рецепта в поле выше, чтобы увидеть результаты</p>
            </div>
        </div>
    </div>

    <!-- Навигация -->
    <div class="navigation">
        <a href="add-recipe.jsp" class="nav-link">➕ Добавить рецепт</a>
        <a href="simple-search.jsp" class="nav-link">📋 Обычный поиск</a>
        <a href="../index.html" class="nav-link">🏠 На главную</a>
    </div>

    <script>
        // Глобальные переменные
        let searchTimeout;
        let currentSearchQuery = '';

        // Инициализация при загрузке страницы
        document.addEventListener('DOMContentLoaded', function() {
            initializeSearch();
        });

        function initializeSearch() {
            const searchInput = document.getElementById('searchInput');
            const searchButton = document.getElementById('searchButton');
            const clearButton = document.getElementById('clearButton');
            const suggestionsContainer = document.getElementById('suggestions');

            // Обработчик ввода в поле поиска
            searchInput.addEventListener('input', function(e) {
                currentSearchQuery = e.target.value.trim();
                clearTimeout(searchTimeout);
                
                if (currentSearchQuery.length >= 2) {
                    searchTimeout = setTimeout(function() {
                        fetchSuggestions(currentSearchQuery);
                    }, 300); // Задержка 300мс
                } else {
                    hideSuggestions();
                }
            });

            // Обработчик клика по кнопке поиска
            searchButton.addEventListener('click', function() {
                performSearch();
            });

            // Обработчик клавиши Enter
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });

            // Обработчик очистки
            clearButton.addEventListener('click', function() {
                clearSearch();
            });

            // Закрытие подсказок при клике вне области
            document.addEventListener('click', function(e) {
                if (!searchInput.contains(e.target) && !suggestionsContainer.contains(e.target)) {
                    hideSuggestions();
                }
            });
        }

        // Запрос подсказок для автодополнения
        async function fetchSuggestions(query) {
            try {
                const response = await fetch('../RecipesList?action=searchSuggest&q=' + encodeURIComponent(query) + '&limit=5');
                
                if (!response.ok) {
                    throw new Error('Ошибка получения подсказок');
                }
                
                const suggestions = await response.json();
                displaySuggestions(suggestions);
                
            } catch (error) {
                console.error('Ошибка:', error);
                hideSuggestions();
            }
        }

        // Отображение подсказок
        function displaySuggestions(suggestions) {
            const container = document.getElementById('suggestions');
            
            if (suggestions.length === 0) {
                hideSuggestions();
                return;
            }
            
            let html = '';
            for (let i = 0; i < suggestions.length; i++) {
                const suggestion = suggestions[i];
                html += 
                    '<div class="suggestion-item" onclick="selectSuggestion(\'' + escapeHtml(suggestion.name) + '\')">' +
                    '<div class="suggestion-name">' + escapeHtml(suggestion.name) + '</div>' +
                    '<div class="suggestion-desc">' + escapeHtml(suggestion.description) + '</div>' +
                    '</div>';
            }
            
            container.innerHTML = html;
            container.style.display = 'block';
        }

        // Скрытие подсказок
        function hideSuggestions() {
            const container = document.getElementById('suggestions');
            container.style.display = 'none';
        }

        // Выбор подсказки
        function selectSuggestion(recipeName) {
            document.getElementById('searchInput').value = recipeName;
            hideSuggestions();
            performSearch();
        }

        // Выполнение поиска
        async function performSearch() {
            const query = document.getElementById('searchInput').value.trim();
            const category = document.getElementById('categoryFilter').value;
            const maxTime = document.getElementById('timeFilter').value;
            
            if (!query) {
                showMessage('⚠️ Введите запрос для поиска', 'warning');
                return;
            }
            
            showLoading();
            
            try {
                // Формируем URL с параметрами
                let url = '../RecipesList?action=asyncSearch&q=' + encodeURIComponent(query);
                if (category) url += '&category=' + encodeURIComponent(category);
                if (maxTime) url += '&maxTime=' + encodeURIComponent(maxTime);
                
                const response = await fetch(url);
                
                if (!response.ok) {
                    throw new Error('Ошибка поиска');
                }
                
                const results = await response.json();
                displayResults(results);
                
            } catch (error) {
                console.error('Ошибка поиска:', error);
                showMessage('❌ Ошибка при выполнении поиска. Попробуйте еще раз.', 'error');
            }
        }

        // Отображение результатов поиска
        function displayResults(results) {
            const container = document.getElementById('resultsContent');
            
            if (results.length === 0) {
                container.innerHTML = 
                    '<div class="no-results">' +
                    '<h3>😔 Рецепты не найдены</h3>' +
                    '<p>Попробуйте изменить запрос или параметры фильтрации</p>' +
                    '</div>';
                return;
            }
            
            let html = '';
            for (let i = 0; i < results.length; i++) {
                const recipe = results[i];
                const categoryName = getCategoryName(recipe.category);
                const isUserRecipe = recipe.isUserRecipe;
                
                html += 
                    '<div class="recipe-card">' +
                    '<div class="recipe-title">' +
                    escapeHtml(recipe.name) +
                    (isUserRecipe ? '<span class="user-recipe-badge">⭐ Пользовательский</span>' : '') +
                    '</div>' +
                    '<div class="recipe-meta">' +
                    '<span>⏱️ ' + recipe.cookingTime + ' мин</span>' +
                    '<span>🍽️ ' + categoryName + '</span>' +
                    '<span>👨‍🍳 ' + escapeHtml(recipe.author) + '</span>' +
                    '</div>' +
                    '<div class="recipe-ingredients">' +
                    '<strong>Ингредиенты:</strong><br>' +
                    formatIngredients(recipe.ingredients) +
                    '</div>' +
                    '</div>';
            }
            
            container.innerHTML = html;
        }

        // Показать загрузку
        function showLoading() {
            const container = document.getElementById('resultsContent');
            container.innerHTML = 
                '<div class="loading-spinner">' +
                '<div class="spinner"></div>' +
                '<p>Ищем рецепты...</p>' +
                '</div>';
        }

        // Показать сообщение
        function showMessage(message, type) {
            const container = document.getElementById('resultsContent');
            const bgColor = type === 'error' ? '#ffebee' : '#fff3cd';
            const borderColor = type === 'error' ? '#f44336' : '#ffc107';
            
            container.innerHTML = 
                '<div class="error-message" style="background: ' + bgColor + '; border-left-color: ' + borderColor + '">' +
                message +
                '</div>';
        }

        // Очистка поиска
        function clearSearch() {
            document.getElementById('searchInput').value = '';
            document.getElementById('categoryFilter').value = '';
            document.getElementById('timeFilter').value = '';
            
            const container = document.getElementById('resultsContent');
            container.innerHTML = 
                '<div class="no-results">' +
                '<h3>🔍 Начните поиск</h3>' +
                '<p>Введите название рецепта в поле выше, чтобы увидеть результаты</p>' +
                '</div>';
            
            hideSuggestions();
        }

        // Вспомогательные функции
        function escapeHtml(text) {
            if (text === null || text === undefined) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function getCategoryName(category) {
            const categories = {
                'main': 'Основное блюдо',
                'soup': 'Суп',
                'salad': 'Салат',
                'dessert': 'Десерт',
                'drink': 'Напиток',
                'bakery': 'Выпечка',
                'snack': 'Закуска'
            };
            return categories[category] || category;
        }

        function formatIngredients(ingredients) {
            if (!ingredients) return '';
            // Преобразуем текстовые ингредиенты в читаемый вид
            return ingredients.split('\n')
                .map(function(line) { return line.trim(); })
                .filter(function(line) { return line.length > 0; })
                .map(function(line) { return '• ' + line; })
                .join('<br>');
        }
    </script>
</body>
</html>