package russianfood.servlets;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import jakarta.servlet.http.*;
import java.io.*;

public class RecipesListServletTest {
    
    @Mock HttpServletRequest request;
    @Mock HttpServletResponse response;
    @Mock HttpSession session;
    
    private RecipesListServlet servlet;
    private StringWriter stringWriter;
    private PrintWriter printWriter;
    
    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        servlet = new RecipesListServlet();
        servlet.init();
        
        // Настройка Writer для захвата вывода
        stringWriter = new StringWriter();
        printWriter = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(printWriter);
    }
    
    // Тест 1: Обычный GET-запрос без параметров
    @Test
    public void testDefaultGetRequest() throws Exception {
        // Настройка mock-объектов
        when(request.getParameter("name")).thenReturn(null);
        when(request.getParameter("author")).thenReturn(null);
        when(request.getParameter("time")).thenReturn(null);
        when(request.getParameter("lang")).thenReturn(null);
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("lang")).thenReturn(null);
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Проверяем, что возвращается HTML страница
        assertTrue("Должен содержать HTML doctype", result.contains("<!DOCTYPE html>"));
        assertTrue("Должен содержать заголовок", result.contains("Русская кухня"));
        assertTrue("Должен содержать рецепт Борщ", result.contains("Борщ"));
        assertTrue("Должен содержать рецепт Блины", result.contains("Блины"));
    }
    
    // Тест 2: GET-запрос с параметрами фильтрации
    @Test
    public void testGetRequestWithFilters() throws Exception {
        // Настройка mock-объектов с параметрами
        when(request.getParameter("name")).thenReturn("Шеф");
        when(request.getParameter("author")).thenReturn("Иванов И.И.");
        when(request.getParameter("time")).thenReturn("60");
        when(request.getParameter("lang")).thenReturn("ru");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("lang")).thenReturn("ru");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        assertTrue("Должен содержать имя пользователя", result.contains("Шеф"));
        assertTrue("Должен содержать фильтр автора", result.contains("Иванов И.И."));
        assertTrue("Должен содержать фильтр времени", result.contains("60"));
    }
    
    // Тест 3: AJAX поиск с автодополнением
    @Test
    public void testSearchSuggestions() throws Exception {
        // Настройка параметров для автодополнения
        when(request.getParameter("action")).thenReturn("searchSuggest");
        when(request.getParameter("q")).thenReturn("бор");
        when(request.getParameter("limit")).thenReturn("5");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Должен вернуть JSON с подсказками
        assertTrue("Должен возвращать JSON", result.startsWith("["));
        assertTrue("Должен содержать подсказки", result.contains("Борщ"));
    }
    
    // Тест 4: Полноценный AJAX поиск
    @Test
    public void testAsyncSearch() throws Exception {
        // Настройка параметров для поиска
        when(request.getParameter("action")).thenReturn("asyncSearch");
        when(request.getParameter("q")).thenReturn("борщ");
        when(request.getParameter("category")).thenReturn("soup");
        when(request.getParameter("maxTime")).thenReturn("120");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Должен вернуть JSON с результатами поиска
        assertTrue("Должен возвращать JSON", result.startsWith("["));
        assertTrue("Должен содержать рецепт борща", result.contains("Борщ"));
        assertTrue("Должен содержать ингредиенты", result.contains("Свекла"));
    }
    
    // Тест 5: Добавление рецепта через POST
    @Test
    public void testAddRecipe() throws Exception {
        // Настройка параметров для добавления рецепта
        when(request.getParameter("action")).thenReturn("addRecipe");
        when(request.getParameter("name")).thenReturn("Тестовый рецепт");
        when(request.getParameter("ingredients")).thenReturn("- Мука 200г\n- Яйца 2шт");
        when(request.getParameter("instructions")).thenReturn("1. Смешать ингредиенты\n2. Приготовить");
        when(request.getParameter("cookingTime")).thenReturn("30");
        when(request.getParameter("category")).thenReturn("main");
        when(request.getParameter("author")).thenReturn("Тестовый автор");
        
        // Настройка кодировки
        when(request.getCharacterEncoding()).thenReturn("UTF-8");
        
        // Создаем новый StringWriter для этого теста
        StringWriter postWriter = new StringWriter();
        PrintWriter postPrintWriter = new PrintWriter(postWriter);
        when(response.getWriter()).thenReturn(postPrintWriter);
        
        // Вызов тестируемого метода
        servlet.doPost(request, response);
        
        // Проверки
        postPrintWriter.flush();
        String result = postPrintWriter.toString();
        
        // После добавления рецепта должен быть редирект
        // или сообщение об успехе
        verify(response, atLeastOnce()).sendRedirect(anyString());
    }
    
    // Тест 6: Получение деталей рецепта
    @Test
    public void testGetRecipeDetails() throws Exception {
        // Настройка параметров
        when(request.getParameter("action")).thenReturn("getRecipeDetails");
        when(request.getParameter("name")).thenReturn("Борщ");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Должен вернуть JSON с деталями рецепта
        assertTrue("Должен возвращать JSON", result.startsWith("{"));
        assertTrue("Должен содержать название рецепта", result.contains("Борщ"));
        assertTrue("Должен содержать ингредиенты", result.contains("Свекла"));
    }
    
    // Тест 7: Поиск несуществующего рецепта
    @Test
    public void testSearchNonExistentRecipe() throws Exception {
        // Настройка параметров для поиска несуществующего рецепта
        when(request.getParameter("action")).thenReturn("asyncSearch");
        when(request.getParameter("q")).thenReturn("несуществующийрецепт");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Должен вернуть пустой JSON массив
        assertEquals("Должен вернуть пустой массив", "[]", result.trim());
    }
    
    // Тест 8: Проверка работы с сессией (язык интерфейса)
    @Test
    public void testSessionLanguage() throws Exception {
        // Настройка mock-объектов с английским языком
        when(request.getParameter("name")).thenReturn(null);
        when(request.getParameter("author")).thenReturn(null);
        when(request.getParameter("time")).thenReturn(null);
        when(request.getParameter("lang")).thenReturn("en");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("lang")).thenReturn("en");
        
        // Вызов тестируемого метода
        servlet.doGet(request, response);
        
        // Проверки
        printWriter.flush();
        String result = stringWriter.toString();
        
        // Должен содержать английские элементы интерфейса
        assertTrue("Должен содержать английскую кнопку", result.contains("English"));
    }
}