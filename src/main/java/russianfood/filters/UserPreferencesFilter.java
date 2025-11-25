package russianfood.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebFilter("/*")
public class UserPreferencesFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Получаем или создаем сессию
        HttpSession session = httpRequest.getSession(true);
        
        // Инициализируем счетчик посещений
        Integer visitCount = (Integer) session.getAttribute("visitCount");
        if (visitCount == null) {
            visitCount = 1;
        } else {
            visitCount++;
        }
        session.setAttribute("visitCount", visitCount);
        
        // Обновляем дату последнего визита
        String lastVisit = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
        session.setAttribute("lastVisit", lastVisit);
        
        // Проверяем наличие cookie с настройками
        checkAndSetDefaultCookies(httpRequest, httpResponse);
        
        chain.doFilter(request, response);
    }
    
    private void checkAndSetDefaultCookies(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        boolean hasUserColor = false;
        boolean hasUserName = false;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("userColor".equals(cookie.getName())) {
                    hasUserColor = true;
                }
                if ("userName".equals(cookie.getName())) {
                    hasUserName = true;
                }
            }
        }
        
        // Устанавливаем cookie по умолчанию, если их нет
        if (!hasUserColor) {
            Cookie colorCookie = new Cookie("userColor", "theme-blue");
            colorCookie.setMaxAge(60 * 60 * 24 * 30); // 30 дней
            colorCookie.setPath("/");
            response.addCookie(colorCookie);
        }
        
        if (!hasUserName && request.getRemoteUser() != null) {
            // Используем логин как имя по умолчанию
            String userName = capitalizeFirstLetter(request.getRemoteUser());
            Cookie nameCookie = new Cookie("userName", userName);
            nameCookie.setMaxAge(60 * 60 * 24 * 30); // 30 дней
            nameCookie.setPath("/");
            response.addCookie(nameCookie);
        }
    }
    
    private String capitalizeFirstLetter(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}