<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Login administrador - Get It Gym">
        <meta name="author" content="Get It Gym">
        <title>Login Administrador - Get It Gym</title>

        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/templatemo-training-studio.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loginCSS.css">
    </head>

    <body>
        <!-- Logo flotante -->
        <div id="floating-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo2.png" alt="Get It Gym">
        </div>

        <!-- Header -->
        <header class="header-area header-sticky">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <nav class="main-nav">
                            <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                            <ul class="nav">
                                <li><a href="index.html">Inicio</a></li>
                                <li><a href="registroClientes.jsp">Registro</a></li>
                                <li><a href="index.html#our-classes">Clases</a></li>
                                <li><a href="index.html#schedule">Horarios</a></li>
                                <li><a href="index.html#contact-us">Contacto</a></li>
                                <li class="main-button"><a href="loginPanelAdmin.jsp">Iniciar Sesión</a></li>
                            </ul>
                            <a class='menu-trigger'><span>Menú</span></a>
                        </nav>
                    </div>
                </div>
            </div>
        </header>

        <!-- Login Form -->
        <div class="login-container">
            <div class="login-box">
                <h2>Panel Administrador</h2>
                <form action="LoginServlet" method="post">
                    <div class="form-group">
                        <input type="text" name="usuario" class="form-control" placeholder="Usuario" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" class="form-control" placeholder="Contraseña" required>
                    </div>
                    <button type="submit">Ingresar</button>
                </form>

                <a href="index.html" class="back-link">← Volver al inicio</a>
            </div>
        </div>

        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <p>© 2025 Get It Gym - Administradores</p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/custom.js"></script>
    </body>
</html>
