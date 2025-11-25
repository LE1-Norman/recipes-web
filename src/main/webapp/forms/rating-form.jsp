<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Оценка сайта - Русская кухня</title>
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
        input, select, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
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
        .rating-stars {
            display: flex;
            gap: 10px;
            margin: 10px 0;
        }
        .star {
            font-size: 24px;
            cursor: pointer;
            color: #ddd;
        }
        .star:hover,
        .star.active {
            color: #ffc107;
        }
        .rating-value {
            font-weight: bold;
            color: #ff6b00;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>⭐ Оцените наш сайт</h1>
        <p>Пожалуйста, оцените ваше впечатление от использования сайта с рецептами русской кухни</p>
        
        <form method="POST" action="${pageContext.request.contextPath}/RatingServlet">
            
            <div class="form-group">
                <label for="userName">Ваше имя:</label>
                <input type="text" id="userName" name="userName" 
                       placeholder="Введите ваше имя" required>
            </div>
            
            <div class="form-group">
                <label>Оценка сайта:</label>
                <div class="rating-stars" id="ratingStars">
                    <span class="star" data-value="1">★</span>
                    <span class="star" data-value="2">★</span>
                    <span class="star" data-value="3">★</span>
                    <span class="star" data-value="4">★</span>
                    <span class="star" data-value="5">★</span>
                </div>
                <input type="hidden" id="rating" name="rating" value="0" required>
                <div>Выбранная оценка: <span id="ratingDisplay" class="rating-value">0 из 5</span></div>
            </div>
            
            <div class="form-group">
    			<label>Что вам понравилось?</label>
    			<div class="checkbox-group">
        			<label><input type="checkbox" name="likedFeatures" value="design"> Дизайн сайта</label>
        			<label><input type="checkbox" name="likedFeatures" value="recipes"> Рецепты</label>
        			<label><input type="checkbox" name="likedFeatures" value="usability"> Удобство использования</label>
        			<label><input type="checkbox" name="likedFeatures" value="content"> Содержание</label>
    			</div>
			</div>
            
            <div class="form-group">
                <label for="comments">Ваши комментарии и предложения:</label>
                <textarea id="comments" name="comments" 
                         placeholder="Что вам понравилось или что можно улучшить?"></textarea>
            </div>
            
            <div class="form-group">
                <label for="email">Email (для обратной связи, необязательно):</label>
                <input type="email" id="email" name="email" 
                       placeholder="your@email.com">
            </div>
            
            <input type="submit" value="Отправить оценку" class="btn">
        </form>
        
        <div style="margin-top: 20px; background-color: #e8f5e8; padding: 15px; border-radius: 5px;">
            <h3>📊 Статистика оценок:</h3>
            <p>Средняя оценка: <strong>4.2 из 5</strong></p>
            <p>Всего оценок: <strong>47</strong></p>
        </div>
        
        <p style="margin-top: 20px;">
            <a href="simple-search.jsp">🔍 Простой поиск рецептов</a><br>
            <a href="add-recipe.jsp">➕ Добавить новый рецепт</a><br>
            <a href="../index.html">🏠 На главную</a>
        </p>
    </div>

    <script>
        // JavaScript для звезд рейтинга
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star');
            const ratingInput = document.getElementById('rating');
            const ratingDisplay = document.getElementById('ratingDisplay');
            
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const value = this.getAttribute('data-value');
                    ratingInput.value = value;
                    ratingDisplay.textContent = value + ' из 5';
                    
                    // Подсвечиваем звезды
                    stars.forEach(s => {
                        if (s.getAttribute('data-value') <= value) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });
                
                // Эффект при наведении
                star.addEventListener('mouseover', function() {
                    const value = this.getAttribute('data-value');
                    stars.forEach(s => {
                        if (s.getAttribute('data-value') <= value) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#ddd';
                        }
                    });
                });
                
                star.addEventListener('mouseout', function() {
                    const currentRating = ratingInput.value;
                    stars.forEach(s => {
                        if (s.getAttribute('data-value') <= currentRating) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#ddd';
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>