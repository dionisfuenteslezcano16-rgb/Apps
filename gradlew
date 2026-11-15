#!/bin/sh
APP_HOME=$(cd "$(dirname "$0")" && pwd -P)
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"

if [ ! -f "$WRAPPER_JAR" ]; then
  echo "Falta $WRAPPER_JAR. Ejecuta 'gradle wrapper --gradle-version 8.11.1' o compila en GitHub Actions."
  exit 1
fi

exec java -Xmx2048m -Dorg.gradle.appname=gradlew -classpath "$WRAPPER_JAR" org.gradle.wrapper.GradleWrapperMain "$@"
