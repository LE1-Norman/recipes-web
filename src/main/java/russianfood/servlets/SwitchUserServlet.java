package russianfood.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/switch-user")
public class SwitchUserServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Принудительно завершаем текущую сессию
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Создаем новый запрос к защищенной странице, чтобы активировать j_security_check
        String targetPage = request.getParameter("page");
        if (targetPage == null) {
            targetPage = "/forms/add-recipe.jsp";
        }
        
        // Сохраняем целевую страницу в новой сессии
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("targetPage", targetPage);
        
        // Перенаправляем на защищенную страницу, чтобы активировать форму входа
        response.sendRedirect(request.getContextPath() + targetPage);
    }
}