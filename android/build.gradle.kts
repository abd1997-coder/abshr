import com.android.build.gradle.LibraryExtension
import org.gradle.kotlin.dsl.configure

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    // Align Kotlin Gradle plugin across subprojects (Flutter recommends Kotlin 2.1+).
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "org.jetbrains.kotlin" && requested.name == "kotlin-gradle-plugin") {
                useVersion("2.1.10")
                because("Flutter Android builds require Kotlin 2.1+")
            }
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensure evaluation order for :app
subprojects {
    project.evaluationDependsOn(":app")
}

// Workaround for plugins (e.g., some pub-cache plugins) that don't specify
// the Android library namespace in their module build.gradle. AGP 7+ requires
// a namespace. This sets a sensible default for any library module that
// doesn't provide one, avoiding the "Namespace not specified" error.
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<LibraryExtension> {
            if (namespace.isNullOrBlank()) {
                namespace = "com.example.${project.name.replace('-', '_')}"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
