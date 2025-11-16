<%-- 
    Document   : registroClientes.jsp
    Created on : 15 nov 2025, 6:09:24 p.m.
    Author     : jorge
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Registro - Get It Gym</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-awesome.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/templatemo-training-studio.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registro.css">
  
</head>
<body>

<!-- Header -->
<header class="header-area header-sticky">
  <div class="container">
    <div class="row">
      <div class="col-12">
        <nav class="main-nav">
          <a href="index.html" class="logo">GET IT<em> GYM</em></a>
          <ul class="nav">
            <li><a href="index.html">Inicio</a></li>
            <li><a href="#features#features">Nosotros</a></li>
            <li><a href="index.html#our-classes">Clases</a></li>
            <li><a href="registroClientes.jsp" class="active">Registro</a></li>
            <li class="scroll-to-section"><a href="#contact-us">Contacto</a></li> 
            <li>
              <a href="loginPanelAdmin.jsp" class="btn btn-sm btn-outline-light" style="margin-left:10px; border-radius:20px;">Admin</a>
            </li>
          </ul>
          <a class='menu-trigger'><span>Menu</span></a>
        </nav>
      </div>
    </div>
  </div>
</header>

<!-- Registro -->
<section class="section" id="registro">
  <div class="container mt-5 pt-5">
    <div class="row">
      <div class="col-lg-6 offset-lg-3 text-center">
        <div class="section-heading">
          <h2><em>Regístrate</em> en Get It Gym</h2>
          <img src="assets/images/line-dec.png" alt="">
          <p>Completa el formulario para unirte a nuestro gimnasio y alcanzar tus objetivos fitness.</p>
        </div>
      </div>
    </div>

    <div class="row justify-content-center">
      <div class="col-lg-8">
        <div id="registro-result" class="alert alert-success" role="alert"></div>

        <form id="registro-form" method="post" class="form registro-form p-4 rounded shadow-sm">
          <div class="row">
            <div class="col-md-6 mb-3">
              <input name="nombre" type="text" class="form-control" placeholder="Nombre completo" required>
            </div>
            <div class="col-md-6 mb-3">
              <input name="email" type="email" class="form-control" placeholder="Correo electrónico" required>
            </div>
            <div class="col-md-6 mb-3">
              <input name="telefono" type="text" class="form-control" placeholder="Teléfono" required>
            </div>
            <div class="col-md-6 mb-3">
              <input name="edad" type="number" class="form-control" placeholder="Edad" required>
            </div>

            <div class="col-md-6 mb-3">
              <select name="clase" class="form-control">
                <option value="sin-clase">-- Registrarse sin clase --</option>
                <option value="primera">Primera Clase - Zumba</option>
                <option value="segunda">Segunda Clase - Box</option>
                <option value="tercera">Tercera Clase - Yoga</option>
                <option value="cuarta">Cuarta Clase - HIT</option>
                <option value="quinta">Quinta Clase - Crossfit</option>
              </select>
            </div>

            <div class="col-md-6 mb-3">
              <select name="plazo" class="form-control" required>
                <option value="">-- Selecciona el tipo de pase --</option>
                <option value="diario">Pase Diario - $50 MXN</option>
                <option value="semanal">Pase Semanal - $250 MXN</option>
                <option value="mensual">Pase Mensual - $800 MXN</option>
                <option value="trimestral">Pase Trimestral - $2,000 MXN</option>
                <option value="anual">Pase Anual - $7,000 MXN</option>
              </select>
            </div>

            <div class="col-md-12 mb-3">
              <textarea name="objetivos" rows="4" class="form-control" placeholder="¿Cuáles son tus objetivos? (opcional)"></textarea>
            </div>

            <div class="col-md-12 text-center">
              <button type="submit" class="btn-enviar">Enviar Registro</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</section>

<!-- ***** Contact Us Area Starts ***** -->
    <section class="section" id="contact-us">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-6 col-xs-12">
                    <div id="map">
                      <iframe src="https://www.google.com/maps/embed?pb=!4v1761208990051!6m8!1m7!1sGP4dIkXG5OyS5gKD3zTYXw!2m2!1d27.49187718975163!2d-109.9152702717641!3f351.4052069167525!4f-13.91074720010981!5f0.7820865974627469" width="100%" height="600px" frameborder="0" style="border:0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 col-xs-12">
                    <div class="contact-form">
                        <form id="contact" action="" method="post">
                          <div class="row">
                            <div class="col-md-6 col-sm-12">
                              <fieldset>
                                <input name="name" type="text" id="name" placeholder="Tu nombre*" required="">
                              </fieldset>
                            </div>
                            <div class="col-md-6 col-sm-12">
                              <fieldset>
                                <input name="email" type="text" id="email" pattern="[^ @]*@[^ @]*" placeholder="Tu correo*" required="">
                              </fieldset>
                            </div>
                            <div class="col-md-12 col-sm-12">
                              <fieldset>
                                <input name="subject" type="text" id="subject" placeholder="Asunto">
                              </fieldset>
                            </div>
                            <div class="col-lg-12">
                              <fieldset>
                                <textarea name="message" rows="6" id="message" placeholder="Mensaje" required=""></textarea>
                              </fieldset>
                            </div>
                            <div class="col-lg-12">
                              <fieldset>
                                <button type="submit" id="form-submit" class="main-button">Enviar mensaje</button>
                              </fieldset>
                            </div>
                          </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- ***** Contact Us Area Ends ***** -->
    
    <!-- ***** Footer Start ***** -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <p>© 2025 Get It Gym - Diseñado con ❤️ basado en TemplateMo</p>
                </div>
            </div>
        </div>
    </footer>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}assets/js/jquery-2.1.0.min.js"></script>
<script src="${pageContext.request.contextPath}assets/js/popper.js"></script>
<script src="${pageContext.request.contextPath}assets/js/bootstrap.min.js"></script>

<script>
  document.getElementById('registro-form').addEventListener('submit', function(e) {
    e.preventDefault();
    const result = document.getElementById('registro-result');
    result.innerText = 'Registro enviado correctamente. ¡Bienvenido a Get It Gym!';
    result.style.display = 'block';
    this.reset();
    setTimeout(() => result.style.display = 'none', 4000);
  });
</script>

</body>
</html>
