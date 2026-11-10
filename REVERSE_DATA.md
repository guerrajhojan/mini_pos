# Reverse Data

Cuaderno de investigacion para reconstruir, paso a paso, la estructura y el
comportamiento de la aplicacion de referencia. Las respuestas deben basarse en
lo que se observe en la aplicacion, su documentacion o sus contratos; evitar
presentar suposiciones como hechos.

## Como usar este documento

Para cada pregunta, registrar:

- **Respuesta:** lo observado o confirmado.
- **Evidencia:** pantalla, flujo, documentacion o ejemplo de datos que lo
  respalda. No incluir credenciales, tokens ni datos personales.
- **Estado:** `Pendiente`, `Parcial` o `Confirmado`.
- **Decision de implementacion:** como se aplicara a este proyecto.

Se puede avanzar en orden o resolver primero las preguntas de la pantalla de
Productos. Mantener las decisiones provisionales identificadas hasta poder
contrastarlas con la referencia.

## Acuerdos provisionales actuales

Estos puntos se mencionaron durante la planificacion, pero deben validarse
contra la aplicacion de referencia antes de considerarse definitivos:

- Usar **Cubit** para el estado; la dependencia y la estructura aun deben
  implementarse.
- Usar **GoRouter** como base de navegacion; su configuracion aun debe
  implementarse.
- Mientras no haya API, usar modelos y un repositorio local con datos de
  muestra, disenado para poder sustituir su implementacion por una API.
- Perfiles inicialmente considerados: **Administrador**, **Vendedor** y
  **Almacenista**. Sus permisos y el flujo de cambio de perfil estan pendientes.
- Moneda propuesta: **USD**.
- Stock propuesto: `0` o menos significa agotado; de `1` a `5` significa bajo
  stock. Los valores negativos deben ser visibles como alerta de inventario.
- Diseno adaptable propuesto: `NavigationBar` en movil y navegacion lateral en
  pantallas amplias, con breakpoints centralizados y modificables.
- Las respuestas de una API, su esquema y las reglas de negocio reales aun no
  estan disponibles.

## Preguntas de investigacion

### A. Pantalla de Productos

#### 1. Campos del producto

**Pregunta:** ¿Que campos tiene realmente un producto? Por ejemplo: nombre,
SKU, codigo de barras, categoria, precio, costo, stock, presentacion, imagen,
vencimiento o proveedor. ¿Cuales son obligatorios?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 2. Metricas del encabezado

**Pregunta:** ¿Como se calculan “Total”, “Valor total” y “Alertas”? ¿El valor
total usa precio de venta, costo u otra formula?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 3. Estados y cantidades de stock

**Pregunta:** ¿Que umbral define “Bajo stock”? ¿Se permite stock negativo?
¿Una cantidad negativa se muestra como agotado, como alerta separada o de otra
forma?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Parcial — hay una regla provisional en “Acuerdos provisionales
  actuales”.
- **Decision de implementacion:**

#### 4. Filtros y ordenamiento

**Pregunta:** ¿Que filtros y opciones de ordenamiento ofrece la aplicacion?
Por ejemplo: categoria, disponibilidad, vencimiento, nombre o precio.

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 5. Busqueda

**Pregunta:** ¿La busqueda considera nombre, SKU y codigo de barras? ¿Filtra
mientras se escribe o requiere confirmacion? ¿Puede devolver varios
resultados?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 6. Acciones sobre productos

**Pregunta:** ¿Se puede crear, editar y eliminar un producto? ¿La eliminacion
es definitiva o se desactiva el producto? ¿Que campos se pueden modificar y
que confirmaciones se requieren?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 7. Escaner de codigos

**Pregunta:** ¿Que ocurre al escanear un codigo existente? ¿Abre el producto,
lo agrega a una venta u otra operacion? ¿Que sucede si el codigo no existe?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

### B. Datos y arquitectura

#### 8. Origen de datos y contratos

**Pregunta:** ¿De donde obtiene la aplicacion los productos y las metricas?
¿Usa API, base de datos local o ambas? Si hay documentacion, ¿cuales son las
rutas, parametros y ejemplos de respuesta?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente — no se dispone aun de API ni de su esquema.
- **Decision de implementacion:**

#### 9. Modo sin conexion y errores

**Pregunta:** ¿Que muestra y permite hacer la aplicacion si no hay conexion o
falla la carga? ¿Usa datos guardados, permite cambios pendientes de sincronizar
o muestra un error con opcion de reintentar?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 10. Perfiles, permisos y sesiones

**Pregunta:** ¿Que perfiles existen y que acciones puede realizar cada uno?
¿Como se cambia de perfil, como se inicia/cierra sesion y como se conservan
los permisos?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Parcial — Administrador, Vendedor y Almacenista son perfiles
  propuestos, no confirmados; permisos pendientes.
- **Decision de implementacion:**

#### 11. Entidades relacionadas

**Pregunta:** ¿Con que otras entidades se relacionan los productos, como
categorias, sucursales, proveedores, inventario, ventas y facturas? ¿El stock
es global o cambia por sucursal?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

### C. Experiencia y diseno

#### 12. Estados de la interfaz

**Pregunta:** ¿Que muestra la aplicacion durante carga, catalogo vacio,
busqueda sin resultados, error, guardado exitoso y confirmacion de
eliminacion?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Pendiente
- **Decision de implementacion:**

#### 13. Formatos y reglas regionales

**Pregunta:** ¿Que moneda, formato decimal, separadores numericos, formato de
fechas e idioma usa la aplicacion?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Parcial — USD es una propuesta por confirmar.
- **Decision de implementacion:**

#### 14. Adaptacion a tamanos de pantalla

**Pregunta:** ¿A partir de que ancho cambia la navegacion inferior por la
lateral? ¿Cambian las tarjetas, el numero de columnas o la distribucion del
contenido en movil, tablet y escritorio?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Parcial — se propone `NavigationBar` en movil y navegacion
  lateral en pantallas amplias; faltan anchos observados.
- **Decision de implementacion:**

#### 15. Detalles visuales

**Pregunta:** ¿Que tipografia, colores, imagenes/logotipo, espaciados,
bordes, iconos y comportamientos del encabezado deben replicarse? ¿Hay
diferencias entre movil, tablet y escritorio?

- **Respuesta:**
- **Evidencia:**
- **Estado:** Parcial — hay capturas de referencia; falta documentar medidas
  y detalles visuales confirmados.
- **Decision de implementacion:**

## Registro de decisiones

| Fecha | Pregunta(s) | Decision | Evidencia o motivo |
|---|---|---|---|
| 2026-11-10 | Arquitectura inicial | Cubit, GoRouter, repositorio local provisional y diseno adaptable. Validar estos acuerdos con la referencia antes de ampliarlos. | Respuestas de planificacion del proyecto. |
