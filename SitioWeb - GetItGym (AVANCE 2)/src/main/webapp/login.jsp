<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Iniciar Sesión - Get It Gym</title>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loginCSS.css"> 
    </head>
    
    <body>

        <header class="header-area">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <nav class="main-nav">
                            <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                            
                            <ul class="nav">
                                <li><a href="index.html#top">Inicio</a></li>
                                <li><a href="index.html#features">Nosotros</a></li>
                                <li><a href="index.html#our-classes">Clases</a></li>
                                <li><a href="index.html#schedule">Horarios</a></li>
                                <li><a href="index.html#contact-us">Contacto</a></li>
                                <li class="nav-btn"><a href="registroClientes.jsp">Registrarse</a></li>
                            </ul>
                   
                        </nav>
                    </div>
                </div>
            </div>
        </header>

        <div class="auth-container">
            <div class="glass-box box-login">
                
                <div class="text-center mb-4">
                    <img src="assets/images/logo2.png" alt="Get It Gym" style="width: 120px; filter: drop-shadow(0 0 5px rgba(0,0,0,0.5)); margin-bottom: 10px;">
                    <h3>Bienvenido</h3>
                    <p style="margin-bottom: 0;">Entrena duro, vive mejor.</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger text-center" style="background: rgba(220,53,69,0.2); border: 1px solid #dc3545; color: #ffb3b3; font-size: 0.9rem; padding: 10px;">
                        <i class="fa fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <% if ("exito".equals(request.getParameter("registro"))) { %>
                    <div class="alert alert-success text-center" style="background: rgba(40,167,69,0.2); border: 1px solid #28a745; color: #b3ffcc; font-size: 0.9rem; padding: 10px;">
                        <i class="fa fa-check-circle"></i> ¡Cuenta creada! Inicia sesión.
                    </div>
                <% } %>

                <form action="AuthServlet" method="post">
                    <div class="form-group">
                        <label>Usuario o Email</label>
                        <input type="text" name="credencial" class="form-control" placeholder="admin o cliente@gmail.com" required autocomplete="off">
                    </div>
                    
                    <div class="form-group">
                        <label>Contraseña</label>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                    
                    <button type="submit" class="btn-main">INGRESAR</button>
                </form>

                <div class="text-center mt-4">
                    <p style="color: #999; margin-bottom: 5px; font-size: 0.9rem;">¿Aún no eres miembro?</p>
                    <a href="registroClientes.jsp" style="color: #fb030a; font-weight: 600; text-decoration: none;">
                        Regístrate aquí <i class="fa fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <footer>
            <div class="container">
                <p>© 2025 Get It Gym - Tu mejor versión.</p>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/custom.js"></script>
    </body>
</html>