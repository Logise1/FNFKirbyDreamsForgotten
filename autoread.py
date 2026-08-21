import threading
import time
import tkinter as tk
import keyboard
import pyautogui

# Reducir el retardo interno de pyautogui
pyautogui.PAUSE = 0.05

running = False
countdown_active = False


def update_status(text, color="#FFFFFF"):
    status_label.config(text=text, fg=color)


def run_bot_loop():
    global running, countdown_active

    # Fase 1: Cuenta atrás de 15 segundos
    countdown_active = True
    for i in range(15, 0, -1):
        if not countdown_active:
            update_status("Cancelado", "#FF5555")
            return
        update_status(f"Iniciando en {i}s...\n(Haz clic en Discord)", "#FFAA00")
        time.sleep(1)

    countdown_active = False
    running = True
    update_status("Ejecutando...\nPulsa 'Q' para detener", "#55FF55")

    # Fase 2: Bucle de marcado saltando entre servidores
    while running:
        # 1. Marcar el servidor actual como leído por completo
        pyautogui.hotkey("shift", "esc")
        time.sleep(0.15)

        # 2. Saltar directamente al siguiente servidor de la lista
        # (Ctrl + Alt + Down navega por la barra lateral de servidores)
        pyautogui.hotkey("ctrl", "alt", "down")
        time.sleep(0.15)

    update_status("Detenido por usuario", "#FF5555")
    start_btn.config(state="normal")


def start_process():
    global running, countdown_active
    if not running and not countdown_active:
        start_btn.config(state="disabled")
        thread = threading.Thread(target=run_bot_loop, daemon=True)
        thread.start()


def stop_process():
    global running, countdown_active
    running = False
    countdown_active = False
    start_btn.config(state="normal")
    update_status("Detenido (Pulsa Iniciar)", "#FFFFFF")


# Listener global de teclado para detener con la tecla 'Q'
def listen_emergency_key():
    keyboard.add_hotkey("q", stop_process)


# Configuración del Overlay con Tkinter
root = tk.Tk()
root.title("Discord AutoRead")
root.geometry("260x160+40+40")  # Posición arriba a la izquierda
root.attributes("-topmost", True)  # Siempre visible encima de Discord
root.attributes("-alpha", 0.88)  # Semitransparencia
root.configure(bg="#1E1F22")
root.resizable(False, False)

title_label = tk.Label(
    root, text="Discord Auto-Read", font=("Arial", 11, "bold"), fg="#5865F2", bg="#1E1F22"
)
title_label.pack(pady=(10, 4))

status_label = tk.Label(
    root, text="Listo para iniciar", font=("Arial", 9), fg="#FFFFFF", bg="#1E1F22"
)
status_label.pack(pady=4)

btn_frame = tk.Frame(root, bg="#1E1F22")
btn_frame.pack(pady=8)

start_btn = tk.Button(
    btn_frame,
    text="Iniciar",
    command=start_process,
    bg="#23A55A",
    fg="white",
    font=("Arial", 9, "bold"),
    relief="flat",
    padx=8,
)
start_btn.pack(side="left", padx=4)

stop_btn = tk.Button(
    btn_frame,
    text="Parar (Q)",
    command=stop_process,
    bg="#DA373C",
    fg="white",
    font=("Arial", 9, "bold"),
    relief="flat",
    padx=8,
)
stop_btn.pack(side="left", padx=4)

# Iniciar hilo del listener de teclado global
key_thread = threading.Thread(target=listen_emergency_key, daemon=True)
key_thread.start()

root.mainloop()