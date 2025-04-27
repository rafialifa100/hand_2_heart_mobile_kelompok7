allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
android {
    compileSdkVersion 33  // Versi SDK yang digunakan (sesuaikan dengan versi SDK yang kamu gunakan)
    defaultConfig {
        // Konfigurasi lainnya
    }
    ndkVersion = "27.0.12077973"  // Menambahkan versi NDK yang sesuai
}
