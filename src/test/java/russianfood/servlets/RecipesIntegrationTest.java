package russianfood.servlets;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import jakarta.servlet.http.*;
import java.io.*;

public class RecipesIntegrationTest {
    
    @Mock HttpServletRequest request;
    @Mock HttpServletResponse response;
    @Mock HttpSession session;
    
    private RecipesListServlet servlet;
    
    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        servlet = new RecipesListServlet();
        servlet.init();
    }
    
    // Самый важный тест - полный цикл работы
    @Test
    public void testCompleteWorkflow() throws Exception {
        // 1. ПОЛЬЗОВАТЕЛЬ ДОБАВЛЯЕТ РЕЦЕПТ
        when(request.getParameter("action")).thenReturn("addRecipe");
        when(request.getParameter("name")).thenReturn("Мой тестовый рецепт");
        when(request.getParameter("ingredients")).thenReturn("- Тест 100г");
        when(request.getParameter("instructions")).thenReturn("1. Приготовить");
        when(request.getParameter("cookingTime")).thenReturn("20");
        when(request.getParameter("category")).thenReturn("main");
        when(request.getParameter("author")).thenReturn("Я");
        when(request.getCharacterEncoding()).thenReturn("UTF-8");
        
        StringWriter writer1 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer1));
        
        servlet.doPost(request, response);
        
        // Проверяем, что редирект на успех
        verify(response).sendRedirect(contains("recipe-added.jsp"));
        
        // 2. ПОЛЬЗОВАТЕЛЬ ИЩЕТ СВОЙ РЕЦЕПТ
        when(request.getParameter("action")).thenReturn("asyncSearch");
        when(request.getParameter("q")).thenReturn("Мой тестовый");
        
        StringWriter writer2 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer2));
        
        servlet.doGet(request, response);
        
        // Проверяем, что нашел
        String searchResult = writer2.toString();
        assertTrue("Должен найти мой рецепт", searchResult.contains("Мой тестовый рецепт"));
        
        // 3. ПОЛЬЗОВАТЕЛЬ СМОТРИТ ДЕТАЛИ
        when(request.getParameter("action")).thenReturn("getRecipeDetails");
        when(request.getParameter("name")).thenReturn("Мой тестовый рецепт");
        
        StringWriter writer3 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer3));
        
        servlet.doGet(request, response);
        
        // Проверяем детали
        String details = writer3.toString();
        assertTrue("Должен вернуть ингредиенты", details.contains("Тест 100г"));
    }
    
    // Тест смены языка
    @Test
    public void testLanguageSwitchWorkflow() throws Exception {
        // 1. Устанавливаем русский язык
        when(request.getParameter("lang")).thenReturn("ru");
        when(request.getSession()).thenReturn(session);
        
        StringWriter writer1 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer1));
        
        servlet.doGet(request, response);
        
        String russianPage = writer1.toString();
        assertTrue("Должен быть русский", russianPage.contains("Русская кухня"));
        
        // 2. Меняем на английский
        when(request.getParameter("lang")).thenReturn("en");
        when(session.getAttribute("lang")).thenReturn("en");
        
        StringWriter writer2 = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer2));
        
        servlet.doGet(request, response);
        
        String englishPage = writer2.toString();
        assertTrue("Должен быть английский", englishPage.contains("Russian Cuisine"));
    }
}