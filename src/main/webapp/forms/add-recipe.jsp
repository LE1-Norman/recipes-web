<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Добавить рецепт - Русская кухня</title>
    <style>
        .form-container { 
            max-width: 700px; 
            margin: 20px auto; 
            padding: 20px; 
            border: 1px solid #ddd; 
            border-radius: 8px; 
            background-color: #f9f9f9;
        }
        .form-group { 
            margin-bottom: 20px; 
        }
        label { 
            display: block; 
            margin-bottom: 5px; 
            font-weight: bold; 
        }
        .required::after { 
            content: " *"; 
            color: red; 
        }
        input, select, textarea { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid #ccc; 
            border-radius: 4px; 
            box-sizing: border-box;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .ingredient-row { 
            display: flex; 
            gap: 10px; 
            margin-bottom: 10px; 
            align-items: center; 
        }
        .ingredient-name { flex: 2; } 
        .ingredient-amount { flex: 1; } 
        .ingredient-unit { flex: 1; }
        .btn { 
            background-color: #4CAF50; 
            color: white; 
            padding: 12px 24px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            margin-right: 10px;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-add { 
            background-color: #2196F3; 
        }
        .btn-add:hover {
            background-color: #1976D2;
        }
        .btn-reset {
            background-color: #f44336;
        }
        .btn-reset:hover {
            background-color: #d32f2f;
        }
        .remove-btn {
            background: #ff4444;
            color: white;
            border: none;
            border-radius: 3px;
            padding: 5px 10px;
            cursor: pointer;
        }
        .info-panel {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
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

    <!-- Отображение приветствия -->
    <div style="background: #f8f9fa; padding: 10px; border-radius: 5px; margin: 10px auto; max-width: 700px; border: 1px solid #ddd;">
        <strong>👋 Привет, <%= !userName.isEmpty() ? userName : request.getRemoteUser() %>!</strong>
        | <a href="<%= request.getContextPath() %>/user/preferences.jsp">🎨 Настройки</a>
        | <a href="<%= request.getContextPath() %>/switch-user">🔐 Сменить пользователя</a>
    </div>
    
    <div class="form-container">
        <h1>➕ Добавить новый рецепт</h1>
        
        <!-- ИНФОРМАЦИЯ О ТОМ, КУДА ОТПРАВЛЯЮТСЯ ДАННЫЕ -->
        <div class="info-panel">
            <p><strong>📝 Форма сохраняет рецепт в общий список</strong></p>
            <p>После добавления рецепт будет доступен для просмотра в общем списке рецептов</p>
        </div>
        
        <!-- ОСНОВНАЯ ФОРМА -->
        <form method="POST" action="${pageContext.request.contextPath}/RecipesList" id="recipeForm">
            
            <!-- СКРЫТОЕ ПОЛЕ ДЛЯ ОПРЕДЕЛЕНИЯ ДЕЙСТВИЯ -->
            <input type="hidden" name="action" value="addRecipe">
            
            <!-- НАЗВАНИЕ РЕЦЕПТА -->
            <div class="form-group">
                <label for="name" class="required">Название рецепта:</label>
                <input type="text" id="name" name="name" required
                       placeholder="Например: Куриные котлеты, Борщ, Оливье..."
                       minlength="3" maxlength="100">
            </div>
            
            <!-- КАТЕГОРИЯ -->
            <div class="form-group">
                <label for="category" class="required">Категория:</label>
                <select id="category" name="category" required>
                    <option value="">-- Выберите категорию --</option>
                    <option value="main">Основные блюда</option>
                    <option value="soup">Супы</option>
                    <option value="salad">Салаты</option>
                    <option value="dessert">Десерты</option>
                    <option value="drink">Напитки</option>
                    <option value="bakery">Выпечка</option>
                    <option value="snack">Закуски</option>
                </select>
            </div>
            
            <!-- ВРЕМЯ ПРИГОТОВЛЕНИЯ -->
            <div class="form-group">
                <label for="cookingTime" class="required">Время приготовления (минут):</label>
                <input type="number" id="cookingTime" name="cookingTime" 
                       required min="5" max="480" value="30"
                       placeholder="Введите время в минутах">
            </div>
            
            <!-- ИНГРЕДИЕНТЫ -->
            <div class="form-group">
                <label class="required">Ингредиенты:</label>
                <div id="ingredients-container">
                    <!-- ПЕРВЫЙ ИНГРЕДИЕНТ -->
                    <div class="ingredient-row">
                        <input type="text" class="ingredient-name" placeholder="Название ингредиента" required>
                        <input type="text" class="ingredient-amount" placeholder="Количество" required>
                        <select class="ingredient-unit" required>
                            <option value="г">грамм</option>
                            <option value="кг">килограмм</option>
                            <option value="мл">миллилитр</option>
                            <option value="л">литр</option>
                            <option value="шт">штук</option>
                            <option value="ч.л.">чайная ложка</option>
                            <option value="ст.л.">столовая ложка</option>
                            <option value="щепотка">щепотка</option>
                            <option value="по вкусу">по вкусу</option>
                            <option value="">без единицы</option>
                        </select>
                        <button type="button" class="remove-btn" onclick="removeIngredient(this)" disabled>❌</button>
                    </div>
                </div>
                <button type="button" class="btn btn-add" onclick="addIngredient()">
                    ➕ Добавить еще ингредиент
                </button>
                
                <!-- СКРЫТОЕ ПОЛЕ ДЛЯ СОБРАННЫХ ИНГРЕДИЕНТОВ -->
                <input type="hidden" id="ingredients" name="ingredients" value="">
            </div>
            
            <!-- ИНСТРУКЦИЯ ПРИГОТОВЛЕНИЯ -->
            <div class="form-group">
                <label for="instructions" class="required">Инструкция приготовления:</label>
                <textarea id="instructions" name="instructions" 
                         placeholder="Опишите пошагово процесс приготовления. Например:
1. Нарезать овощи...
2. Обжарить на сковороде...
3. Тушить под крышкой..." 
                         rows="6" required></textarea>
            </div>
            
            <!-- АВТОР -->
            <div class="form-group">
                <label for="author" class="required">Ваше имя (автор):</label>
                <input type="text" id="author" name="author" required
                       placeholder="Введите ваше имя"
                       value="Анонимный пользователь">
            </div>
            
            <!-- КНОПКИ -->
            <div class="form-group">
                <input type="submit" value="✅ Сохранить рецепт" class="btn" onclick="return prepareForm()">
                <input type="reset" value="❌ Очистить форму" class="btn btn-reset">
                <button type="button" class="btn" onclick="fillSampleData()" style="background-color: #9C27B0;">
                    🧪 Заполнить пример
                </button>
            </div>
        </form>
        
        <!-- НАВИГАЦИЯ -->
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd;">
            <a href="simple-search.jsp" style="margin-right: 15px;">🔍 Поиск рецептов</a>
            <a href="rating-form.jsp" style="margin-right: 15px;">⭐ Оценить сайт</a>
            <a href="../index.html">🏠 На главную</a>
        </div>
    </div>

    <script>
        // Счетчик ингредиентов
        let ingredientCount = 1;
        
        // Добавление нового ингредиента
        function addIngredient() {
            const container = document.getElementById('ingredients-container');
            const newRow = document.createElement('div');
            newRow.className = 'ingredient-row';
            newRow.innerHTML = `
                <input type="text" class="ingredient-name" placeholder="Название ингредиента" required>
                <input type="text" class="ingredient-amount" placeholder="Количество" required>
                <select class="ingredient-unit" required>
                    <option value="г">грамм</option>
                    <option value="кг">килограмм</option>
                    <option value="мл">миллилитр</option>
                    <option value="л">литр</option>
                    <option value="шт">штук</option>
                    <option value="ч.л.">чайная ложка</option>
                    <option value="ст.л.">столовая ложка</option>
                    <option value="щепотка">щепотка</option>
                    <option value="по вкусу">по вкусу</option>
                    <option value="">без единицы</option>
                </select>
                <button type="button" class="remove-btn" onclick="removeIngredient(this)">❌</button>
            `;
            container.appendChild(newRow);
            ingredientCount++;
            
            // Активируем кнопки удаления
            updateRemoveButtons();
        }
        
        // Удаление ингредиента
        function removeIngredient(button) {
            if (ingredientCount > 1) {
                button.parentElement.remove();
                ingredientCount--;
                updateRemoveButtons();
            }
        }
        
        // Обновление состояния кнопок удаления
        function updateRemoveButtons() {
            const removeButtons = document.querySelectorAll('.remove-btn');
            if (ingredientCount > 1) {
                removeButtons.forEach(btn => btn.disabled = false);
            } else {
                removeButtons.forEach(btn => btn.disabled = true);
            }
        }
        
        // Подготовка формы перед отправкой - сбор ингредиентов
        function prepareForm() {
            if (!validateForm()) {
                return false;
            }
            collectIngredients();
            return true;
        }
        
        // Сбор всех ингредиентов в один текст
        function collectIngredients() {
            const ingredientRows = document.querySelectorAll('.ingredient-row');
            let ingredientsText = '';
            
            ingredientRows.forEach(row => {
                const name = row.querySelector('.ingredient-name').value.trim();
                const amount = row.querySelector('.ingredient-amount').value.trim();
                const unit = row.querySelector('.ingredient-unit').value;
                
                if (name && amount) {
                    let ingredientLine = `- ${name}`;
                    if (amount) ingredientLine += ` ${amount}`;
                    if (unit) ingredientLine += ` ${unit}`;
                    ingredientsText += ingredientLine + '\n';
                }
            });
            
            document.getElementById('ingredients').value = ingredientsText;
        }
        
        // Валидация формы
        function validateForm() {
            const recipeName = document.getElementById('name').value.trim();
            if (recipeName.length < 3) {
                alert('❌ Название рецепта должно содержать минимум 3 символа');
                document.getElementById('name').focus();
                return false;
            }
            
            // Проверяем, что есть хотя бы один заполненный ингредиент
            let hasIngredients = false;
            document.querySelectorAll('.ingredient-row').forEach(row => {
                const name = row.querySelector('.ingredient-name').value.trim();
                const amount = row.querySelector('.ingredient-amount').value.trim();
                if (name && amount) {
                    hasIngredients = true;
                }
            });
            
            if (!hasIngredients) {
                alert('❌ Добавьте хотя бы один ингредиент');
                return false;
            }
            
            const instructions = document.getElementById('instructions').value.trim();
            if (instructions.length < 10) {
                alert('❌ Инструкция приготовления должна содержать минимум 10 символов');
                document.getElementById('instructions').focus();
                return false;
            }
            
            return true;
        }

        // Заполнение формы примером данных (ПРОСТАЯ ВЕРСИЯ БЕЗ JSP ВЫРАЖЕНИЙ)
        function fillSampleData() {
            // Очищаем форму
            document.getElementById('recipeForm').reset();
            
            // Заполняем основные поля
            document.getElementById('name').value = 'Куриные котлеты';
            document.getElementById('category').value = 'main';
            document.getElementById('cookingTime').value = '30';
            document.getElementById('instructions').value = '1. Куриный фарш смешать с луком и яйцом\n2. Добавить соль и перец по вкусу\n3. Сформировать котлеты и обжарить на сковороде с двух сторон до золотистой корочки\n4. Подавать с гарниром';
            document.getElementById('author').value = 'Мария Петрова';
            
            // Очищаем контейнер ингредиентов и добавляем первый ряд
            const container = document.getElementById('ingredients-container');
            container.innerHTML = '';
            
            // Создаем первый ингредиент
            const firstRow = document.createElement('div');
            firstRow.className = 'ingredient-row';
            firstRow.innerHTML = `
                <input type="text" class="ingredient-name" placeholder="Название ингредиента" required>
                <input type="text" class="ingredient-amount" placeholder="Количество" required>
                <select class="ingredient-unit" required>
                    <option value="г">грамм</option>
                    <option value="кг">килограмм</option>
                    <option value="мл">миллилитр</option>
                    <option value="л">литр</option>
                    <option value="шт">штук</option>
                    <option value="ч.л.">чайная ложка</option>
                    <option value="ст.л.">столовая ложка</option>
                    <option value="щепотка">щепотка</option>
                    <option value="по вкусу">по вкусу</option>
                    <option value="">без единицы</option>
                </select>
                <button type="button" class="remove-btn" onclick="removeIngredient(this)" disabled>❌</button>
            `;
            container.appendChild(firstRow);
            
            // Примерные ингредиенты
            const sampleIngredients = [
                { name: 'Куриный фарш', amount: '500', unit: 'г' },
                { name: 'Лук репчатый', amount: '1', unit: 'шт' },
                { name: 'Яйцо', amount: '1', unit: 'шт' },
                { name: 'Соль', amount: '1', unit: 'ч.л.' },
                { name: 'Перец черный', amount: '0.5', unit: 'ч.л.' }
            ];
            
            // Заполняем ингредиенты через прямое присвоение значений
            const rows = container.querySelectorAll('.ingredient-row');
            
            // Сначала заполняем существующие строки
            sampleIngredients.forEach((ingredient, index) => {
                if (index < rows.length) {
                    // Заполняем существующую строку
                    const row = rows[index];
                    row.querySelector('.ingredient-name').value = ingredient.name;
                    row.querySelector('.ingredient-amount').value = ingredient.amount;
                    
                    // Устанавливаем выбранную единицу измерения
                    const unitSelect = row.querySelector('.ingredient-unit');
                    const options = unitSelect.options;
                    for (let i = 0; i < options.length; i++) {
                        if (options[i].value === ingredient.unit) {
                            unitSelect.selectedIndex = i;
                            break;
                        }
                    }
                } else {
                    // Добавляем новую строку если нужно
                    addIngredient();
                    const newRow = container.querySelector('.ingredient-row:last-child');
                    newRow.querySelector('.ingredient-name').value = ingredient.name;
                    newRow.querySelector('.ingredient-amount').value = ingredient.amount;
                    
                    const unitSelect = newRow.querySelector('.ingredient-unit');
                    const options = unitSelect.options;
                    for (let i = 0; i < options.length; i++) {
                        if (options[i].value === ingredient.unit) {
                            unitSelect.selectedIndex = i;
                            break;
                        }
                    }
                }
            });
            
            ingredientCount = sampleIngredients.length;
            updateRemoveButtons();
            
            alert('✅ Форма заполнена примером данных! Теперь можно нажать "Сохранить рецепт"');
        }
        
        // Инициализация при загрузке страницы
        document.addEventListener('DOMContentLoaded', function() {
            updateRemoveButtons();
        });
    </script>
</body>
</html>