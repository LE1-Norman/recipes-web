package russianfood.servlets;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import jakarta.servlet.http.*;
import java.io.*;

public class UserWorkflowTest {
    
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
    
    // Тестируем типичный сценарий пользователя
    @Test
    public void testUserTypicalWorkflow() throws Exception {
        // 1. Пользователь заходит на сайт
        when(request.getParameter("name")).thenReturn("Гость");
        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("lang")).thenReturn("ru");
        
        StringWriter writer1 = new StringWriter();
        PrintWriter printWriter1 = new PrintWriter(writer1);
        when(response.getWriter()).thenReturn(printWriter1);
        
        servlet.doGet(request, response);
        
        printWriter1.flush();
        String mainPage = writer1.toString();
        assertTrue("Должны быть стандартные рецепты: " + mainPage, 
                  mainPage.contains("Борщ") && mainPage.contains("Блины"));
        
        // 2. Пользователь ищет рецепты - СБРАСЫВАЕМ ПАРАМЕТРЫ
        when(request.getParameter("action")).thenReturn("asyncSearch");
        when(request.getParameter("q")).thenReturn("мука");
        when(request.getParameter("category")).thenReturn("main");
        when(request.getParameter("maxTime")).thenReturn(null); // сбрасываем время
        when(request.getParameter("name")).thenReturn(null); // сбрасываем имя
        when(request.getParameter("author")).thenReturn(null); // сбрасываем автора
        when(request.getParameter("lang")).thenReturn(null); // сбрасываем язык
        when(request.getSession()).thenReturn(session); // оставляем сессию
        when(session.getAttribute("lang")).thenReturn(null); // сбрасываем язык в сессии
        
        StringWriter writer2 = new StringWriter();
        PrintWriter printWriter2 = new PrintWriter(writer2);
        when(response.getWriter()).thenReturn(printWriter2);
        
        servlet.doGet(request, response);
        
        printWriter2.flush();
        String searchResults = writer2.toString();
        assertTrue("Должен найти рецепты с мукой: " + searchResults, 
                  searchResults.contains("Блины") || searchResults.contains("Пельмени"));
        
        // 3. Пользователь фильтрует по времени
        when(request.getParameter("maxTime")).thenReturn("30");
        
        StringWriter writer3 = new StringWriter();
        PrintWriter printWriter3 = new PrintWriter(writer3);
        when(response.getWriter()).thenReturn(printWriter3);
        
        servlet.doGet(request, response);
        
        printWriter3.flush();
        String filteredResults = writer3.toString();
        assertTrue("Должен найти быстрые рецепты: " + filteredResults, 
                  filteredResults.contains("Блины"));
    }
}