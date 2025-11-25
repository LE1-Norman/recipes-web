package russianfood.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

@WebServlet(
    name = "RecipesListServlet",
    description = "Сервлет для отображения рецептов с GET параметрами",
    urlPatterns = { "/RecipesList" }
)
public class RecipesListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private String defaultUserName;
    private int defaultCookingTime;
    
    // Список для хранения пользовательских рецептов
    private static List<Recipe> userRecipes = new ArrayList<>();
    
    // Внутренний класс Recipe
    public static class Recipe {
        private String name;
        private String ingredients;
        private String instructions;
        private int cookingTime;
        private String category;
        private String author;
        
        public Recipe(String name, String ingredients, String instructions, 
                     int cookingTime, String category, String author) {
            this.name = name;
            this.ingredients = ingredients;
            this.instructions = instructions;
            this.cookingTime = cookingTime;
            this.category = category;
            this.author = author;
        }
        
        // Геттеры
        public String getName() { return name; }
        public String getIngredients() { return ingredients; }
        public String getInstructions() { return instructions; }
        public int getCookingTime() { return cookingTime; }
        public String getCategory() { return category; }
        public String getAuthor() { return author; }
    }
    
    @Override
    public void init() throws ServletException {
        defaultUserName = "Шеф";
        defaultCookingTime = 120;
    }

    // Обработка различных типов запросов
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("searchSuggest".equals(action)) {
            // AJAX-поиск для автодополнения
            handleSearchSuggestions(request, response);
        } else if ("asyncSearch".equals(action)) {
            // Полноценный AJAX-поиск
            handleAsyncSearch(request, response);
        } else if ("getRecipeDetails".equals(action)) {
            // Получение деталей рецепта для списка покупок
            handleGetRecipeDetails(request, response);
        } else {
            // Существующая логика для обычных запросов
            handleRegularGetRequest(request, response);
        }
    }
    
    // Метод для обычных GET запросов (перенесен из старого doGet)
    private void handleRegularGetRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        String userName = request.getParameter("name");
        String authorFilter = request.getParameter("author");
        String timeFilter = request.getParameter("time");
        String lang = request.getParameter("lang");
        
        HttpSession session = request.getSession();
        if (lang != null) {
            session.setAttribute("lang", lang);
        }
        String currentLang = (String) session.getAttribute("lang");
        if (currentLang == null) {
            currentLang = "ru";
        }
        
        Locale locale = new Locale(currentLang);
        ResourceBundle messages = ResourceBundle.getBundle("messages", locale);
        
        if (userName == null || userName.trim().isEmpty()) {
            userName = defaultUserName;
        }
        
        if (authorFilter == null) {
            authorFilter = "";
        }
        
        int cookingTimeFilter = defaultCookingTime;
        if (timeFilter != null) {
            try {
                cookingTimeFilter = Integer.parseInt(timeFilter);
            } catch (NumberFormatException e) {
                // Оставляем значение по умолчанию
            }
        }
        
        String translatedUserName = translateName(userName, messages);
        String translatedAuthorFilter = translateAuthor(authorFilter, messages);
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='" + currentLang + "'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <title>" + messages.getString("title") + "</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("        .container { max-width: 800px; margin: 0 auto; }");
        out.println("        .lang-buttons { margin-bottom: 20px; }");
        out.println("        .lang-btn { padding: 5px 10px; margin: 0 5px; cursor: pointer; }");
        out.println("        .filter-info { background: #f0f8ff; padding: 15px; border-radius: 5px; margin: 15px 0; }");
        out.println("        ul { list-style: none; padding: 0; }");
        out.println("        li { background: white; margin: 10px 0; padding: 15px; border-radius: 5px; border: 1px solid #ddd; }");
        out.println("        .user-recipe { background: #f0fff0; border-left: 4px solid #4CAF50; }");
        out.println("        .add-recipe-btn { background: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 10px 0; }");
        out.println("        .recipe-count { background: #e7f3ff; padding: 10px; border-radius: 5px; margin: 10px 0; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='container'>");
        
        out.println("    <div class='lang-buttons'>");
        out.println("        <span>" + messages.getString("language") + ": </span>");
        out.println("        <a href='RecipesList?lang=ru'><button class='lang-btn'>Русский</button></a>");
        out.println("        <a href='RecipesList?lang=en'><button class='lang-btn'>English</button></a>");
        out.println("    </div>");
        
        out.println("    <h1>🍲 " + messages.getString("title") + "</h1>");
        out.println("    <h2>" + MessageFormat.format(messages.getString("greeting"), escapeHtml(translatedUserName)) + "</h2>");
        out.println("    <p>" + messages.getString("description") + "</p>");
        
        // Кнопка добавления рецепта
        out.println("    <a href='forms/add-recipe.jsp' class='add-recipe-btn'>➕ " + 
                   (currentLang.equals("ru") ? "Добавить свой рецепт" : "Add Your Recipe") + "</a>");
        
        out.println("    <div class='filter-info'>");
        out.println("        <strong>" + messages.getString("filter") + "</strong><br>");
        out.println("        👤 " + messages.getString("user") + ": " + escapeHtml(translatedUserName) + "<br>");
        out.println("        👨‍🍳 " + messages.getString("author") + ": " + 
                   (translatedAuthorFilter.isEmpty() ? messages.getString("author_all") : escapeHtml(translatedAuthorFilter)) + "<br>");
        out.println("        ⏱️ " + messages.getString("max_time") + ": " + cookingTimeFilter + " " + messages.getString("time_min"));
        out.println("    </div>");
        
        // Статистика рецептов
        out.println("    <div class='recipe-count'>");
        out.println("        📊 " + (currentLang.equals("ru") ? "Всего рецептов: " : "Total recipes: ") + 
                   (4 + userRecipes.size()) + " (" + userRecipes.size() + " " + 
                   (currentLang.equals("ru") ? "пользовательских" : "user") + ")");
        out.println("    </div>");
        
        out.println("    <h3>" + messages.getString("recipes") + "</h3>");
        out.println("    <ul>");
        
        // Стандартные рецепты
        if ((authorFilter.isEmpty() || "Иванов И.И.".equals(authorFilter)) && cookingTimeFilter >= 120) {
            out.println("        <li>");
            out.println("            <strong>" + messages.getString("borscht") + "</strong><br>");
            out.println("            🧅 " + messages.getString("ingredients") + ": " + messages.getString("borscht_ingredients") + "<br>");
            out.println("            ⏱️ " + messages.getString("time") + ": 120 " + messages.getString("time_min") + "<br>");
            out.println("            👨‍🍳 " + messages.getString("author") + ": " + messages.getString("author_ivanov"));
            out.println("        </li>");
        }
        
        if ((authorFilter.isEmpty() || "Петрова А.С.".equals(authorFilter)) && cookingTimeFilter >= 30) {
            out.println("        <li>");
            out.println("            <strong>" + messages.getString("blini") + "</strong><br>");
            out.println("            🧅 " + messages.getString("ingredients") + ": " + messages.getString("blini_ingredients") + "<br>");
            out.println("            ⏱️ " + messages.getString("time") + ": 30 " + messages.getString("time_min") + "<br>");
            out.println("            👩‍🍳 " + messages.getString("author") + ": " + messages.getString("author_petrova"));
            out.println("        </li>");
        }
        
        if ((authorFilter.isEmpty() || "Сидоров В.П.".equals(authorFilter)) && cookingTimeFilter >= 90) {
            out.println("        <li>");
            out.println("            <strong>" + messages.getString("pelmeni") + "</strong><br>");
            out.println("            🧅 " + messages.getString("ingredients") + ": " + messages.getString("pelmeni_ingredients") + "<br>");
            out.println("            ⏱️ " + messages.getString("time") + ": 90 " + messages.getString("time_min") + "<br>");
            out.println("            👨‍🍳 " + messages.getString("author") + ": " + messages.getString("author_sidorov"));
            out.println("        </li>");
        }
        
        if ((authorFilter.isEmpty() || "Кузнецова О.И.".equals(authorFilter)) && cookingTimeFilter >= 40) {
            out.println("        <li>");
            out.println("            <strong>" + messages.getString("olivier") + "</strong><br>");
            out.println("            🧅 " + messages.getString("ingredients") + ": " + messages.getString("olivier_ingredients") + "<br>");
            out.println("            ⏱️ " + messages.getString("time") + ": 40 " + messages.getString("time_min") + "<br>");
            out.println("            👩‍🍳 " + messages.getString("author") + ": " + messages.getString("author_kuznetsova"));
            out.println("        </li>");
        }
        
        // Пользовательские рецепты
        for (Recipe userRecipe : userRecipes) {
            boolean authorMatch = authorFilter.isEmpty() || authorFilter.equals(userRecipe.getAuthor());
            boolean timeMatch = cookingTimeFilter >= userRecipe.getCookingTime();
            
            if (authorMatch && timeMatch) {
                out.println("        <li class='user-recipe'>");
                out.println("            <strong>⭐ " + escapeHtml(userRecipe.getName()) + "</strong><br>");
                out.println("            🧅 " + messages.getString("ingredients") + ": " + escapeHtml(userRecipe.getIngredients()) + "<br>");
                out.println("            📝 " + (currentLang.equals("ru") ? "Инструкция: " : "Instructions: ") + escapeHtml(userRecipe.getInstructions()) + "<br>");
                out.println("            ⏱️ " + messages.getString("time") + ": " + userRecipe.getCookingTime() + " " + messages.getString("time_min") + "<br>");
                out.println("            🏷️ " + (currentLang.equals("ru") ? "Категория: " : "Category: ") + getCategoryName(userRecipe.getCategory(), currentLang) + "<br>");
                out.println("            👨‍🍳 " + messages.getString("author") + ": " + escapeHtml(userRecipe.getAuthor()));
                out.println("        </li>");
            }
        }
        
        out.println("    </ul>");
        
        out.println("    <div style='margin-top: 20px;'>");
        out.println("        <strong>" + messages.getString("examples") + "</strong><br>");
        out.println("        <a href='RecipesList?name=Гость'>" + messages.getString("view_all") + "</a><br>");
        out.println("        <a href='RecipesList?name=Иванов И.И.&author=Иванов И.И.'>" + messages.getString("ivanov_recipes") + "</a><br>");
        out.println("        <a href='RecipesList?name=Повар&time=30'>" + messages.getString("fast_recipes") + "</a><br>");
        out.println("        <a href='RecipesList?name=Шеф&time=120'>" + messages.getString("all_recipes") + "</a>");
        out.println("    </div>");
        
        out.println("</body>");
        out.println("</html>");
    }

    // Метод для автодополнения поиска
    private void handleSearchSuggestions(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String query = request.getParameter("q");
        int limit = 5;
        try {
            limit = Integer.parseInt(request.getParameter("limit"));
        } catch (NumberFormatException e) {
            // Используем значение по умолчанию
        }
        
        PrintWriter out = response.getWriter();
        List<Map<String, String>> suggestions = new ArrayList<>();
        
        if (query != null && query.length() >= 2) {
            String lowerQuery = query.toLowerCase();
            
            // Поиск в стандартных рецептах
            suggestions.addAll(searchInRecipes(lowerQuery, limit));
        }
        
        // Преобразуем в JSON
        String json = convertToJson(suggestions);
        out.print(json);
    }

    // Метод для полноценного асинхронного поиска
    private void handleAsyncSearch(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String query = request.getParameter("q");
        String category = request.getParameter("category");
        String maxTime = request.getParameter("maxTime");
        
        PrintWriter out = response.getWriter();
        List<Map<String, Object>> searchResults = new ArrayList<>();
        
        if (query != null && !query.trim().isEmpty()) {
            String lowerQuery = query.toLowerCase();
            
            // Поиск по всем рецептам
            searchResults.addAll(searchRecipesFull(lowerQuery, category, maxTime));
        }
        
        String json = convertSearchResultsToJson(searchResults);
        out.print(json);
    }

    // Метод для получения деталей рецепта (для списка покупок)
    private void handleGetRecipeDetails(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String recipeName = request.getParameter("name");
        PrintWriter out = response.getWriter();
        
        Map<String, Object> recipeDetails = findRecipeByName(recipeName);
        
        if (recipeDetails != null) {
            String json = convertToJson(recipeDetails);
            out.print(json);
        } else {
            // Рецепт не найден
            out.print("{\"error\": \"Рецепт не найден\"}");
        }
    }

    // Поиск рецептов для автодополнения
    private List<Map<String, String>> searchInRecipes(String query, int limit) {
        List<Map<String, String>> results = new ArrayList<>();
        
        // Поиск в стандартных рецептах
        String[] standardRecipes = {"Борщ", "Оливье", "Блины", "Пельмени", "Щи", "Бефстроганов"};
        String[] standardDescriptions = {
            "Классический красный борщ", 
            "Салат Оливье", 
            "Русские блины", 
            "Домашние пельмени", 
            "Квашеные щи", 
            "Говядина по-строгановски"
        };
        
        for (int i = 0; i < standardRecipes.length && results.size() < limit; i++) {
            if (standardRecipes[i].toLowerCase().contains(query)) {
                Map<String, String> suggestion = new HashMap<>();
                suggestion.put("name", standardRecipes[i]);
                suggestion.put("description", standardDescriptions[i]);
                results.add(suggestion);
            }
        }
        
        // Поиск в пользовательских рецептах
        synchronized (userRecipes) {
            for (Recipe recipe : userRecipes) {
                if (results.size() >= limit) break;
                
                if (recipe.getName().toLowerCase().contains(query)) {
                    Map<String, String> suggestion = new HashMap<>();
                    suggestion.put("name", recipe.getName());
                    suggestion.put("description", "Пользовательский рецепт");
                    results.add(suggestion);
                }
            }
        }
        
        return results;
    }

    // Полнотекстовый поиск рецептов
    private List<Map<String, Object>> searchRecipesFull(String query, String category, String maxTime) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        int maxCookingTime = maxTime != null ? Integer.parseInt(maxTime) : Integer.MAX_VALUE;
        
        // Поиск в стандартных рецептах
        addStandardRecipesToResults(results, query, category, maxCookingTime);
        
        // Поиск в пользовательских рецептах
        synchronized (userRecipes) {
            for (Recipe recipe : userRecipes) {
                if (matchesSearch(recipe, query, category, maxCookingTime)) {
                    results.add(createRecipeMap(recipe));
                }
            }
        }
        
        return results;
    }

    // Проверка соответствия рецепта критериям поиска
    private boolean matchesSearch(Recipe recipe, String query, String category, int maxTime) {
        boolean nameMatch = recipe.getName().toLowerCase().contains(query);
        boolean ingredientsMatch = recipe.getIngredients().toLowerCase().contains(query);
        boolean categoryMatch = category == null || category.isEmpty() || 
                               category.equals(recipe.getCategory());
        boolean timeMatch = recipe.getCookingTime() <= maxTime;
        
        return (nameMatch || ingredientsMatch) && categoryMatch && timeMatch;
    }

    // Создание Map для рецепта
    private Map<String, Object> createRecipeMap(Recipe recipe) {
        Map<String, Object> recipeMap = new HashMap<>();
        recipeMap.put("name", recipe.getName());
        recipeMap.put("ingredients", recipe.getIngredients());
        recipeMap.put("instructions", recipe.getInstructions());
        recipeMap.put("cookingTime", recipe.getCookingTime());
        recipeMap.put("category", recipe.getCategory());
        recipeMap.put("author", recipe.getAuthor());
        recipeMap.put("isUserRecipe", true);
        return recipeMap;
    }

    // Поиск рецепта по имени
    private Map<String, Object> findRecipeByName(String recipeName) {
        if (recipeName == null) return null;
        
        // Поиск в стандартных рецептах
        Map<String, Object> standardRecipe = findStandardRecipeByName(recipeName);
        if (standardRecipe != null) return standardRecipe;
        
        // Поиск в пользовательских рецептах
        synchronized (userRecipes) {
            for (Recipe recipe : userRecipes) {
                if (recipe.getName().equalsIgnoreCase(recipeName)) {
                    return createRecipeMap(recipe);
                }
            }
        }
        
        return null;
    }

    // Вспомогательные методы для стандартных рецептов
    private void addStandardRecipesToResults(List<Map<String, Object>> results, String query, 
                                            String category, int maxTime) {
        // Борщ
        if (("борщ".contains(query) || "свекла".contains(query) || "капуста".contains(query)) && 
            (category == null || "soup".equals(category)) && maxTime >= 120) {
            results.add(createStandardBorschtMap());
        }
        
        // Блины
        if (("блины".contains(query) || "мука".contains(query) || "молоко".contains(query)) && 
            (category == null || "main".equals(category)) && maxTime >= 30) {
            results.add(createStandardBliniMap());
        }
        
        // Пельмени
        if (("пельмени".contains(query) || "мука".contains(query) || "мясо".contains(query) || "фарш".contains(query)) && 
            (category == null || "main".equals(category)) && maxTime >= 90) {
            results.add(createStandardPelmeniMap());
        }
        
        // Оливье
        if (("оливье".contains(query) || "салат".contains(query) || "картофель".contains(query) || "колбаса".contains(query)) && 
            (category == null || "salad".equals(category)) && maxTime >= 40) {
            results.add(createStandardOlivierMap());
        }
    }

    private Map<String, Object> createStandardBorschtMap() {
        Map<String, Object> recipe = new HashMap<>();
        recipe.put("name", "Борщ");
        recipe.put("ingredients", "- Свекла 2 шт\n- Капуста 200 г\n- Картофель 3 шт\n- Морковь 1 шт\n- Мясо 500 г\n- Лук 1 шт\n- Томатная паста 2 ст.л.");
        recipe.put("instructions", "1. Варим мясной бульон\n2. Нарезаем овощи\n3. Обжариваем лук и морковь\n4. Добавляем свеклу и томатную пасту\n5. Варим до готовности овощей");
        recipe.put("cookingTime", 120);
        recipe.put("category", "soup");
        recipe.put("author", "Иванов И.И.");
        recipe.put("isUserRecipe", false);
        return recipe;
    }

    private Map<String, Object> createStandardBliniMap() {
        Map<String, Object> recipe = new HashMap<>();
        recipe.put("name", "Блины");
        recipe.put("ingredients", "- Мука 200 г\n- Молоко 500 мл\n- Яйца 2 шт\n- Сахар 2 ст.л.\n- Соль щепотка\n- Растительное масло 2 ст.л.");
        recipe.put("instructions", "1. Смешиваем яйца с сахаром и солью\n2. Добавляем молоко и муку\n3. Тщательно перемешиваем\n4. Жарим на разогретой сковороде с двух сторон");
        recipe.put("cookingTime", 30);
        recipe.put("category", "main");
        recipe.put("author", "Петрова А.С.");
        recipe.put("isUserRecipe", false);
        return recipe;
    }

    private Map<String, Object> createStandardPelmeniMap() {
        Map<String, Object> recipe = new HashMap<>();
        recipe.put("name", "Пельмени");
        recipe.put("ingredients", "- Мука 300 г\n- Вода 150 мл\n- Яйцо 1 шт\n- Мясной фарш 500 г\n- Лук 1 шт\n- Соль по вкусу\n- Перец черный молотый");
        recipe.put("instructions", "1. Замешиваем тесто из муки, воды и яйца\n2. Готовим фарш с луком и специями\n3. Раскатываем тесто и вырезаем кружки\n4. Лепим пельмени\n5. Варим в кипящей воде 10-15 минут");
        recipe.put("cookingTime", 90);
        recipe.put("category", "main");
        recipe.put("author", "Сидоров В.П.");
        recipe.put("isUserRecipe", false);
        return recipe;
    }

    private Map<String, Object> createStandardOlivierMap() {
        Map<String, Object> recipe = new HashMap<>();
        recipe.put("name", "Оливье");
        recipe.put("ingredients", "- Картофель 4 шт\n- Морковь 2 шт\n- Яйца 3 шт\n- Колбаса вареная 300 г\n- Огурцы соленые 3 шт\n- Горошек консервированный 200 г\n- Майонез 100 г\n- Соль по вкусу");
        recipe.put("instructions", "1. Отвариваем картофель, морковь и яйца\n2. Охлаждаем и очищаем\n3. Нарезаем все ингредиенты кубиками\n4. Добавляем горошек\n5. Заправляем майонезом и солим\n6. Тщательно перемешиваем");
        recipe.put("cookingTime", 40);
        recipe.put("category", "salad");
        recipe.put("author", "Кузнецова О.И.");
        recipe.put("isUserRecipe", false);
        return recipe;
    }

    private Map<String, Object> findStandardRecipeByName(String name) {
        if ("Борщ".equalsIgnoreCase(name)) return createStandardBorschtMap();
        if ("Блины".equalsIgnoreCase(name)) return createStandardBliniMap();
        if ("Пельмени".equalsIgnoreCase(name)) return createStandardPelmeniMap();
        if ("Оливье".equalsIgnoreCase(name)) return createStandardOlivierMap();
        return null;
    }

    // Методы для конвертации в JSON
    private String convertToJson(List<Map<String, String>> data) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < data.size(); i++) {
            if (i > 0) json.append(",");
            json.append("{");
            Map<String, String> item = data.get(i);
            int count = 0;
            for (Map.Entry<String, String> entry : item.entrySet()) {
                if (count++ > 0) json.append(",");
                json.append("\"").append(entry.getKey()).append("\":\"")
                    .append(escapeJson(entry.getValue())).append("\"");
            }
            json.append("}");
        }
        json.append("]");
        return json.toString();
    }

    private String convertSearchResultsToJson(List<Map<String, Object>> data) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < data.size(); i++) {
            if (i > 0) json.append(",");
            json.append("{");
            Map<String, Object> item = data.get(i);
            int count = 0;
            for (Map.Entry<String, Object> entry : item.entrySet()) {
                if (count++ > 0) json.append(",");
                json.append("\"").append(entry.getKey()).append("\":");
                if (entry.getValue() instanceof String) {
                    json.append("\"").append(escapeJson((String) entry.getValue())).append("\"");
                } else {
                    json.append(entry.getValue());
                }
            }
            json.append("}");
        }
        json.append("]");
        return json.toString();
    }

    private String convertToJson(Map<String, Object> data) {
        StringBuilder json = new StringBuilder("{");
        int count = 0;
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            if (count++ > 0) json.append(",");
            json.append("\"").append(entry.getKey()).append("\":");
            if (entry.getValue() instanceof String) {
                json.append("\"").append(escapeJson((String) entry.getValue())).append("\"");
            } else {
                json.append(entry.getValue());
            }
        }
        json.append("}");
        return json.toString();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
    
    // Обработка POST запросов для добавления рецептов
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Проверяем, это запрос на добавление рецепта
        String action = request.getParameter("action");
        
        if ("addRecipe".equals(action)) {
            addNewRecipe(request, response);
        } else {
            // Если это не добавление рецепта, вызываем обычный doGet
            doGet(request, response);
        }
    }
    
    // Метод для добавления нового рецепта
    private void addNewRecipe(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Получаем параметры из формы
        String name = request.getParameter("name");
        String ingredients = request.getParameter("ingredients");
        String instructions = request.getParameter("instructions");
        String cookingTimeStr = request.getParameter("cookingTime");
        String category = request.getParameter("category");
        String author = request.getParameter("author");
        
        PrintWriter out = response.getWriter();
        
        // Проверяем обязательные поля
        if (name == null || name.trim().isEmpty() ||
            ingredients == null || ingredients.trim().isEmpty() ||
            instructions == null || instructions.trim().isEmpty() ||
            cookingTimeStr == null || cookingTimeStr.trim().isEmpty()) {
            
            showErrorPage(response, 
                "Все обязательные поля должны быть заполнены!", 
                "All required fields must be filled!");
            return;
        }
        
        try {
            int cookingTime = Integer.parseInt(cookingTimeStr);
            
            // Устанавливаем автора по умолчанию
            if (author == null || author.trim().isEmpty()) {
                author = "Анонимный пользователь";
            }
            
            // Создаем и сохраняем рецепт
            Recipe newRecipe = new Recipe(name, ingredients, instructions, cookingTime, category, author);
            synchronized (userRecipes) {
                userRecipes.add(newRecipe);
            }
            
            // Перенаправляем на страницу успеха
            response.sendRedirect(request.getContextPath() + "/forms/recipe-added.jsp");
            
        } catch (NumberFormatException e) {
            showErrorPage(response, 
                "Неверный формат времени приготовления!", 
                "Invalid cooking time format!");
        }
    }
    
    // Метод для отображения страницы ошибки
    private void showErrorPage(HttpServletResponse response, String errorMessageRu, String errorMessageEn) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <title>Ошибка добавления рецепта</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }");
        out.println("        .error { background: #f8d7da; color: #721c24; padding: 20px; border-radius: 5px; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='error'>");
        out.println("        <h1>❌ Ошибка при добавлении рецепта</h1>");
        out.println("        <p>" + errorMessageRu + "</p>");
        out.println("        <p><em>" + errorMessageEn + "</em></p>");
        out.println("        <a href='forms/add-recipe.jsp'>← Вернуться к форме добавления</a>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    // Метод для получения названия категории
    private String getCategoryName(String category, String lang) {
        if ("ru".equals(lang)) {
            switch (category) {
                case "main": return "Основное блюдо";
                case "soup": return "Суп";
                case "salad": return "Салат";
                case "dessert": return "Десерт";
                case "drink": return "Напиток";
                case "bakery": return "Выпечка";
                default: return category;
            }
        } else {
            switch (category) {
                case "main": return "Main Course";
                case "soup": return "Soup";
                case "salad": return "Salad";
                case "dessert": return "Dessert";
                case "drink": return "Drink";
                case "bakery": return "Bakery";
                default: return category;
            }
        }
    }
    
    // Статический метод для получения количества пользовательских рецептов
    public static int getUserRecipeCount() {
        return userRecipes.size();
    }
    
    private String translateName(String name, ResourceBundle messages) {
        if (name == null) return "";
        
        switch (name) {
            case "Шеф": return messages.getString("chef");
            case "Повар": return messages.getString("cook");
            case "Гость": return messages.getString("guest");
            case "Иванов И.И.": return messages.getString("ivanov_full");
            case "Петрова А.С.": return messages.getString("petrova_full");
            default: return name;
        }
    }
    
    private String translateAuthor(String author, ResourceBundle messages) {
        if (author == null || author.isEmpty()) return "";
        
        switch (author) {
            case "Иванов И.И.": return messages.getString("author_ivanov");
            case "Петрова А.С.": return messages.getString("author_petrova");
            case "Сидоров В.П.": return messages.getString("author_sidorov");
            case "Кузнецова О.И.": return messages.getString("author_kuznetsova");
            default: return author;
        }
    }
    
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}