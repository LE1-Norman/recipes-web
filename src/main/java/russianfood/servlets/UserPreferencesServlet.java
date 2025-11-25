package russianfood.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/preferences")
public class UserPreferencesServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userColor = request.getParameter("userColor");
        String userName = request.getParameter("userName");
        
        // Устанавливаем cookie с цветом темы
        if (userColor != null && !userColor.trim().isEmpty()) {
            Cookie colorCookie = new Cookie("userColor", userColor);
            colorCookie.setMaxAge(60 * 60 * 24 * 30); // 30 дней
            colorCookie.setPath("/");
            response.addCookie(colorCookie);
        }
        
        // Устанавливаем cookie с именем
        if (userName != null && !userName.trim().isEmpty()) {
            Cookie nameCookie = new Cookie("userName", userName);
            nameCookie.setMaxAge(60 * 60 * 24 * 30); // 30 дней
            nameCookie.setPath("/");
            response.addCookie(nameCookie);
        }
        
        // Перенаправляем обратно на страницу настроек с сообщением об успехе
        response.sendRedirect(request.getContextPath() + "/user/preferences.jsp?success=true");
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Перенаправляем на JSP страницу настроек
        request.getRequestDispatcher("/user/preferences.jsp").forward(request, response);
    }
}