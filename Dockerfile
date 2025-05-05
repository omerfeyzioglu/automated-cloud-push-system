# --- Dockerfile ---

# Temel imaj olarak hafif bir Java 17 Runtime kullanalım
# Projeniz farklı bir Java sürümü kullanıyorsa (örn: 11), burayı güncelleyin: FROM openjdk:11-jre-slim
FROM openjdk:17-jre-slim

# Çalışma dizinini /app olarak ayarlayalım
WORKDIR /app

# Argüman olarak JAR dosyasının yerini belirtelim (Workflow'dan build edildiğinde target/*.jar olacak)
# Bu, imaj build edilirken dışarıdan değer almayı sağlar, ancak burada varsayılan bir yol veriyoruz.
ARG JAR_FILE=target/*.jar

# Maven'ın oluşturduğu JAR dosyasını imajın içindeki /app dizinine application.jar olarak kopyalayalım
COPY ${JAR_FILE} application.jar

# Uygulamanın çalışacağı port (Spring Boot varsayılanı 8080)
# Bu sadece bilgilendirme amaçlıdır, portu asıl açan uygulama veya run komutudur.
EXPOSE 8080

# İmaj (konteyner) başlatıldığında çalıştırılacak komut
# java -jar /app/application.jar komutunu çalıştırır
ENTRYPOINT ["java", "-jar", "application.jar"]