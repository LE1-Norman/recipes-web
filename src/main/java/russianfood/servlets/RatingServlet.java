package russianfood.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/RatingServlet")
public class RatingServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        // Получаем параметры из формы
        String userName = request.getParameter("userName");
        String rating = request.getParameter("rating");
        String comments = request.getParameter("comments");
        String email = request.getParameter("email");
        String[] likedFeatures = request.getParameterValues("likedFeatures");
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='ru'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <title>Спасибо за оценку!</title>");
        out.println("    <style>");
        out.println("        body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }");
        out.println("        .success { background-color: #d4edda; border: 1px solid #c3e6cb; padding: 20px; border-radius: 5px; }");
        out.println("        .rating { color: #ff6b00; font-weight: bold; font-size: 18px; }");
        out.println("        .features-list { background: #e7f3ff; padding: 10px; border-radius: 5px; margin: 10px 0; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='success'>");
        out.println("        <h1>✅ Спасибо за вашу оценку!</h1>");
        out.println("        <p><strong>" + escapeHtml(userName) + "</strong>, благодарим вас за отзыв!</p>");
        out.println("        <div class='rating'>");
        out.println("            Ваша оценка: " + rating + " из 5 звезд");
        out.println("        </div>");
        
        // Показываем выбранные особенности, если есть
        if (likedFeatures != null && likedFeatures.length > 0) {
            out.println("        <div class='features-list'>");
            out.println("            <strong>Что вам понравилось:</strong>");
            out.println("            <ul>");
            for (String feature : likedFeatures) {
                out.println("                <li>" + getFeatureName(feature) + "</li>");
            }
            out.println("            </ul>");
            out.println("        </div>");
        } else {
            out.println("        <p><strong>Что вам понравилось:</strong> Не указано</p>");
        }
        
        if (comments != null && !comments.trim().isEmpty()) {
            out.println("        <p><strong>Ваш комментарий:</strong><br>" + escapeHtml(comments) + "</p>");
        }
        
        if (email != null && !email.trim().isEmpty()) {
            out.println("        <p><strong>Email для связи:</strong> " + escapeHtml(email) + "</p>");
        }
        
        out.println("        <p>Ваш отзыв поможет нам улучшить сайт!</p>");
        out.println("    </div>");
        
        out.println("    <div style='margin-top: 20px;'>");
        out.println("        <a href='forms/simple-search.jsp'>🔍 Поиск рецептов</a> | ");
        out.println("        <a href='forms/rating-form.jsp'>⭐ Оставить еще одну оценку</a> | ");
        out.println("        <a href='index.html'>🏠 На главную</a>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    private String getFeatureName(String feature) {
        if (feature == null) return "";
        switch (feature) {
            case "design": return "🎨 Дизайн сайта";
            case "recipes": return "📖 Рецепты";
            case "usability": return "💡 Удобство использования";
            case "content": return "📚 Содержание";
            case "navigation": return "🧭 Навигация";
            case "speed": return "⚡ Скорость работы";
            default: return feature;
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