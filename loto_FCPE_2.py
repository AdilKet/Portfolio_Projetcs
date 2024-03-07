import tkinter as tk  # Importation de la bibliothèque Tkinter pour créer l'interface graphique
from tkinter import messagebox  # Importation du module messagebox de Tkinter pour afficher des boîtes de message
import random  # Importation du module random pour générer des nombres aléatoires

def draw_number():
    # Fonction pour tirer un numéro et afficher le résultat dans une boîte de message
    winning_number = random.randint(1, 69)  # Générer un numéro aléatoire entre 1 et 69
    result_text.set(f"Félicitations ! Le numéro gagnant est : {winning_number}")  # Mettre à jour le texte du résultat
    result_label.config(fg="#008000", font=("Arial", 16, "bold"))  # Changer la couleur et agrandir le texte du label de résultat

# Création de la fenêtre principale
root = tk.Tk()  # Créer une instance de la classe Tk() pour la fenêtre principale
root.title("Loto")  # Définir le titre de la fenêtre principale
root.configure(bg="#FFFF00")  # Changer la couleur de fond de la fenêtre principale en jaune

# Création des widgets
label = tk.Label(root, text="Cliquez pour tirer un numéro!", font=("Arial", 14), bg="#FFFF00")  # Créer un label avec le texte spécifié
label.pack(pady=20)  # Placer le label dans la fenêtre principale avec un espacement vertical de 20 pixels

draw_button = tk.Button(root, text="Tirer un numéro", command=draw_number, bg="#FFD700", fg="#FFFFFF", font=("Arial", 12))  # Créer un bouton avec le texte spécifié et la fonction à appeler lorsqu'il est cliqué
draw_button.pack()  # Placer le bouton dans la fenêtre principale

result_text = tk.StringVar()  # Variable pour stocker le texte du résultat
result_label = tk.Label(root, textvariable=result_text, font=("Arial", 14), bg="#FFFF00")  # Créer un label pour afficher le résultat
result_label.pack(pady=10)  # Placer le label de résultat dans la fenêtre principale avec un espacement vertical de 10 pixels

# Lancement de la boucle principale
root.mainloop()  # Lancer la boucle principale pour démarrer l'application et attendre les interactions de l'utilisateur
