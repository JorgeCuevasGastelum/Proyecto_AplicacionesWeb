<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Cliente"%>
<%
    // Seguridad: Si no hay cliente, fuera
    HttpSession ses = request.getSession(false);
    Cliente c = (ses != null) ? (Cliente) ses.getAttribute("clienteLogueado") : null;
    if (c == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>Mi Perfil - Get It Gym</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/templatemo-training-studio.css">
    <style>
        body { background-color: #f4f4f4; }
        .hero-profile {
            background: linear-gradient(rgba(35,45,57,0.9), rgba(35,45,57,0.9)), url('assets/images/cta-bg.jpg');
            background-size: cover;
            height: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .profile-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-top: -60px; /* Efecto traslapado */
        }
        .stat-box {
            background: #f9f9f9;
            border-left: 4px solid #fb030a;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .stat-title { color: #888; font-size: 0.9rem; text-transform: uppercase; font-weight: 600; }
        .stat-value { font-size: 1.5rem; font-weight: 700; color: #232d39; }
        .btn-logout { background-color: #fb030a; color: white; padding: 10px 25px; border-radius: 5px; font-weight: 600; }
        .btn-logout:hover { background-color: #d90206; color: white; }
    </style>
</head>
<body>

    <header class="header-area header-sticky background-header">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <nav class="main-nav">
                        <a href="index.html" class="logo">GET IT<em> GYM</em></a>
                        <ul class="nav">
                            <li><a href="index.html">Inicio</a></li>
                            <li><a href="AuthServlet" class="active">Cerrar Sesión</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </header>

    <div class="hero-profile">
        <div>
            <h1>Hola, <span style="color: #fb030a;"><%= c.getNombre() %></span></h1>
            <p>Bienvenido a tu panel de socio</p>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="profile-card">
                    <div class="row">
                        <div class="col-md-6">
                            <h4 class="mb-4">Tu Membresía</h4>
                            
                            <div class="stat-box">
                                <div class="stat-title"><i class="fa fa-id-card"></i> Plan Actual</div>
                                <div class="stat-value"><%= c.getPlazo() != null ? c.getPlazo().toUpperCase() : "SIN PLAN" %></div>
                            </div>

                            <div class="stat-box">
                                <div class="stat-title"><i class="fa fa-dumbbell"></i> Clase Inscrita</div>
                                <div class="stat-value"><%= c.getClase() != null ? c.getClase() : "Ninguna" %></div>
                            </div>
                            
                            <div class="stat-box">
                                <div class="stat-title"><i class="fa fa-calendar-check-o"></i> Vence el</div>
                                <div class="stat-value" style="color: #fb030a;">
                                    <%= c.getFechaFin() != null ? c.getFechaFin() : "N/A" %>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <h4 class="mb-4">Mis Datos</h4>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><strong>Email:</strong> <%= c.getEmail() %></li>
                                <li class="list-group-item"><strong>Teléfono:</strong> <%= c.getTelefono() %></li>
                                <li class="list-group-item"><strong>Edad:</strong> <%= c.getEdad() %> años</li>
                                <li class="list-group-item"><strong>Objetivo:</strong> <%= c.getObjetivos() %></li>
                            </ul>
                            
                            <div class="mt-4 text-center">
                                <a href="index.html#schedule" class="btn btn-outline-dark btn-block">Ver Horarios de Clases</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/jquery-2.1.0.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/custom.js"></script>
</body>
</html>