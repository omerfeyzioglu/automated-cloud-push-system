# --- Stage 1: Build the application JAR ---
# Build aşaması için JDK içeren bir base image kullanalım (Temurin popüler bir alternatiftir)
FROM eclipse-temurin:17-jdk-focal as builder

# Çalışma dizini
WORKDIR /workspace

# Önce sadece pom.xml'i kopyala (dependency katmanını cachelemek için)
COPY pom.xml .

# Maven bağımlılıklarını indir (sadece pom değişirse bu katman yeniden çalışır)
# Not: Maven cache'ini daha efektif kullanmak için farklı yöntemler de var.
RUN mvn -B dependency:go-offline

# Tüm proje kaynak kodunu kopyala
COPY src ./src

# Uygulamayı derle ve JAR paketini oluştur (testleri atla)
RUN mvn -B package -DskipTests

# --- Stage 2: Create the final lightweight application image ---
# Sonuç imajı için sadece JRE içeren küçük bir base image kullanalım
FROM eclipse-temurin:17-jre-focal

# Çalışma dizini
WORKDIR /app

# Sadece ilk aşamada ('builder') oluşturulan JAR dosyasını kopyala
COPY --from=builder /workspace/target/*.jar application.jar

# Uygulamanın çalışacağı port
EXPOSE 8080

# Konteyner başladığında uygulamayı çalıştıracak komut
ENTRYPOINT ["java", "-jar", "application.jar"]