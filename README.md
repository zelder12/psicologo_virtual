# Psicólogo Virtual

**Descripción**  
Psicólogo Virtual es un asistente diseñado para brindar apoyo psicológico a estudiantes, utilizando técnicas de terapia cognitivo-conductual y ofreciendo orientación en momentos de estrés, ansiedad o desafíos académicos. Este proyecto fue desarrollado por un grupo de estudiantes con el objetivo de proporcionar un espacio de ayuda rápida y confidencial.

## Características
- Interfaz de chat en tiempo real con un asistente especializado en apoyo emocional.
- Respuestas personalizadas basadas en modelos de lenguaje avanzados (OpenAI).
- Buenas prácticas de confidencialidad y ética para el manejo de información sensible.
- Ejemplos de uso de la API de OpenAI para el despliegue de chatbots.

## Estructura Principal
- **lib/**  
    - Contiene los archivos principales de Flutter, incluyendo `main.dart` y las diferentes pantallas.
- **test/**  
    - Tests unitarios y de widget para asegurar el correcto funcionamiento de la aplicación.
- **android**, **web**  
    - Carpetas de configuración específicas para cada plataforma.
- **pubspec.yaml**  
    - Dependencias y configuraciones del proyecto Flutter.

Para más detalles sobre la estructura, revisa la [Documentación del Proyecto](./DOC_DOCUMENT.md).

## Instrucciones de Instalación

1. **Clonar el repositorio**  
     ```bash
     git clone https://github.com/tu-usuario/psicologo-virtual.git
     ```

2. **Instalar dependencias**  
     Desde la carpeta raíz del proyecto, ejecutar:  
     ```bash
     flutter pub get
     ```

3. **Configurar API Keys**  
     En el archivo donde se realiza la llamada a la API (por ejemplo, `ChatScreen.dart`), reemplazar la API Key.  
     Recomendado: Utilizar variables de entorno o un archivo `.env` que no se suba a repositorios públicos.

4. **Ejecutar la aplicación**  
     ```bash
     flutter run
     ```
     - Para Web: `flutter run -d chrome`
     - Para Android: `flutter run -d android`
     - Para iOS: `flutter run -d ios` (requiere entorno de desarrollo en macOS)

## Uso
Al abrir la aplicación se mostrará una pantalla de bienvenida del Psicólogo Virtual.  
Escribe tus preguntas o inquietudes en la barra de texto y pulsa Enviar.  
El chatbot responderá en base a la configuración y el modelo de lenguaje integrado.

## Contribuciones
Si deseas contribuir, realiza un Fork del repositorio, crea una rama con tu feature o fix, y luego abre un Pull Request hacia la rama principal.
