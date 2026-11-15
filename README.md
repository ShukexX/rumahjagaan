# DGH Care Centre

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
## Deploy dengan Dokploy

Repo ini sudah menyediakan `Dockerfile` di root. Di Dokploy:

1. Buat **Application** baru dan hubungkan repository GitHub ini.
2. Pilih branch `main` dan **Build Type: Dockerfile**.
3. Set **Dockerfile Path** ke `Dockerfile` dan **Port** ke `80`.
4. Deploy, lalu tambahkan domain dan aktifkan HTTPS melalui Dokploy.

Docker akan membangun Flutter Web dengan Flutter `3.35.4`, kemudian menyajikannya
dengan Nginx. Konfigurasi Nginx juga sudah menangani client-side routing Flutter.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
