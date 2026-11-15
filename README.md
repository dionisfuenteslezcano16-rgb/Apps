# Visión Video - Android Media3 Live Player & 8D Audio Architecture

Proyecto completo y funcional en un solo módulo `app`.

### ¿Cómo compilar el archivo APK?:
Tienes 2 formas muy rápidas y directas de generar el archivo `.apk` instalable en tu teléfono:

#### Opción 1 (Automática en la nube - 100% Gratis sin instalar nada):
1. Sube este proyecto descomprimido a un repositorio nuevo en tu cuenta de GitHub.
2. La carpeta `.github/workflows/build-apk.yml` ya está incluida.
3. GitHub Actions compilará automáticamente el proyecto usando servidores con JDK 17 y Android SDK.
4. Entra a la pestaña **Actions** en tu repositorio de GitHub, haz clic en el último build y en la sección **Artifacts** descarga tu archivo `VisionVideo-Debug-APK.zip` que contiene el archivo `app-debug.apk` listo para instalar en cualquier Android.

#### Opción 2 (Local en tu PC con Android Studio):
1. Descomprime este archivo `.zip`.
2. Abre **Android Studio** y selecciona **File > Open**, eligiendo la carpeta descomprimida.
3. Espera a que Gradle sincronice las dependencias de Media3 y Compose.
4. En el menú superior, ve a **Build > Build Bundle(s) / APK(s) > Build APK(s)**.
5. Android Studio te mostrará un aviso: *"APK(s) generated successfully"* con un botón **locate** para abrir la carpeta donde está tu archivo `app-debug.apk`.

#### Opción 3 (Vía Terminal con Gradle instalado):
```bash
chmod +x gradlew
./gradlew assembleDebug
# El APK se generará en: app/build/outputs/apk/debug/app-debug.apk
```

### Decisiones de ingeniería resueltas en código:
1. **Motor Media3 ExoPlayer + GlEffect en Vivo**: Cero latencia por hardware, 60/120 FPS sin transcodificar.
2. **8D = AudioProcessor propio**: Paneo sinusoidal equal-power + reverb estéreo (2 comb filters con crossfeed) + modo voice-centered anti-mareo.
3. **Nitidez = Shader GLSL propio**: Máscara laplaciana 4-tap a 60 FPS en GPU.
4. **Export en CoroutineWorker**: FGS con tipo mediaProcessing (35+) / dataSync (29–34); onStopped() limpia temporales.
5. **Scoped Storage**: Entrada con Photo Picker (cero permisos), salida con MediaStore + IS_PENDING; WRITE_EXTERNAL_STORAGE solo ≤ API 28.
6. **Térmica / Throttling**: awaitCoolDown() con PowerManager.currentThermalStatus antes de cada export.
7. **HDR**: Tone-mapping forzado (Composition.HDR_MODE_TONE_MAP_HDR_TO_SDR_USING_OPEN_GL) y rotación automática.
8. **Preset serializable a JSON**: Mismo preset se ejecuta en el móvil y en la nube.