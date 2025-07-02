#!/usr/bin/env python3
import subprocess
import shutil
import os
import sys
from pathlib import Path

def print_section(title):
    print("\n" + "=" * 60)
    print(title)
    print("=" * 60)

def is_installed(cmd):
    return shutil.which(cmd) is not None

def run(command, check=True, capture_output=False, **kwargs):
    try:
        return subprocess.run(command, check=check, capture_output=capture_output, text=True, **kwargs)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error al ejecutar: {' '.join(command)}")
        if capture_output:
            print(e.stderr or e.stdout)
        sys.exit(1)

def install_homebrew():
    print_section("Instalación de Homebrew")
    if is_installed("brew"):
        print("✔ Homebrew ya está instalado.")
        return
    print("🚀 Instalando Homebrew...")
    run(['/bin/bash', '-c', "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"], shell=True)
    print("✅ Homebrew instalado.")

def install_python():
    print_section("Instalación de Python")
    if is_installed("python3"):
        print("✔ Python ya está instalado.")
        return
    run(["brew", "install", "python@3.13"])
    print("✅ Python instalado.")

def install_podman():
    print_section("Instalación de Podman")
    if is_installed("podman"):
        print("✔ Podman ya está instalado.")
        return
    run(["brew", "install", "podman"])
    print("✅ Podman instalado.")

def install_pipx():
    print_section("Instalación de pipx")
    if is_installed("pipx"):
        print("✔ pipx ya está instalado.")
        return
    run(["brew", "install", "pipx"])
    run(["pipx", "ensurepath"])
    print("✅ pipx instalado.")

def ensure_local_bin_in_path():
    local_bin = str(Path.home() / ".local" / "bin")
    zshrc_path = Path.home() / ".zshrc"
    with open(zshrc_path, "r") as f:
        content = f.read()
    if local_bin not in content:
        with open(zshrc_path, "a") as f:
            f.write(f'\n# pipx bin\nexport PATH="$HOME/.local/bin:$PATH"\n')
        print(f"✅ Añadido $HOME/.local/bin al PATH en {zshrc_path}")
        print("ℹ️ Recarga tu shell con: source ~/.zshrc")

def install_podman_compose():
    print_section("Instalación de podman-compose")
    if is_installed("podman-compose"):
        print("✔ podman-compose ya está instalado.")
        return

    # Si pipx no está, instalarlo
    install_pipx()
    ensure_local_bin_in_path()

    print("🚀 Instalando podman-compose con pipx...")
    run(["pipx", "install", "podman-compose"])
    print("✅ podman-compose instalado correctamente con pipx.")

if __name__ == "__main__":
    install_homebrew()
    install_python()
    install_podman()
    install_podman_compose()
    print("\n🎉 Instalaciones finalizadas con éxito.")
